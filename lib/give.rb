require 'commands'
require 'thor'
require 'octokit'
require 'highline/import'
module Give
  class CLI < Thor

    desc "setup OWNER PROJECT", "Forks the project from the specified user/repo"
    def setup(owner, project)
      Give::Project.new(owner, project).fork
    end

    desc "start BRANCH", "Creates a new branch"
    def start(branch)
      Give::Repo.new(:branch => branch).checkout_branch
    end

    desc "update BRANCH", "Updates your master branch with upstream changes, then rebases your working branch"
    def update(branch)
      Give::Repo.new(:branch => branch).update
    end

    desc "finish OWNER PROJECT BRANCH", "Pushes up your working branch, then submits a pull request."
    def finish(owner, project, branch)
      local_repo = Give::Repo.new(:branch => branch)
      local_repo.push
      Give::Project.new(owner, project).send_pull_request(local_repo)
    end

  end

  class Project
    include Commands
    attr_accessor :target_branch, :reference, :client, :user, :owner, :title
    def initialize(owner, title, target_branch='master')
      @owner, @title = owner, title
      @target_branch = target_branch
      @user = User.new
      @client = Octokit::Client.new
    end

    def reference
      @reference ||= [owner, title].join('/')
    end

    def fork
      client.fork!(reference)
      git("clone #{master}")
      sh("cd #{title};git remote add upstream #{upstream}")
    end

    def send_pull_request(repo)
      client.create_pull_request(reference, target_branch, head(repo),
                                 request_title, request_body)
    end

    private

    def head(repo)
      [user.login, repo.branch].join(':')
    end
    
    def local_reference
      [user.login, title].join('/')
    end

    def request_title
      ask("Please enter a title - ")
    end

    def request_body
      ask("Please enter a message -  ")
    end

    def upstream
      "git://github.com/#{reference}.git"
    end

    def master
      "git@github.com:#{local_reference}.git"
    end

  end

  class User
    include Commands
    attr_accessor :login, :token, :endpoint
    def initialize(endpoint=github)
      @login, @token, @endpoint = github_login, github_token, endpoint
      configure
    end

    def configure
      Octokit.configure do |c|
        c.login = login
        c.token = token
        c.endpoint = endpoint
      end
    end

    def github
      "https://github.com"
    end

    def github_login
     git('config --get-all github.user')
    end

    def github_token
      git('config --get-all github.token')
    end

  end

  class Repo
    include Commands
    attr_accessor :branch
    def initialize(opts={})
      @branch = opts.fetch(:branch, 'master')
    end

    def push
      git("push origin #{branch}")
    end

    def update
      git('fetch upstream')
      git('checkout master')
      git('pull upstream master')
      git("checkout #{branch}")
      git('rebase master')
    end

    def checkout_branch
      git("checkout -b #{branch}")
    end

  end
end
