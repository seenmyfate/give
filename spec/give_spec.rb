require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Give::CLI do
  let(:owner)   { 'github_user' }
  let(:project)   { 'give' }
  let(:branch) { 'feaature/my_awesome_feature' }
  let(:upstream_branch) { 'upstream_branch' }
  let(:give)   { Give::CLI.new }
  let(:project)    { stub }
  let(:repo) { stub }

  subject { Give::CLI.new }
  
  context "#setup" do
    it "sets up" do
      Give::Project.should_receive(:new).with(owner, project).and_return(project)
      project.should_receive(:fork)
      subject.setup(owner, project)
    end
  end
  
  context "#start" do
    it "starts" do
      Give::Repo.should_receive(:new).with(:branch => branch).and_return(repo)
      repo.should_receive(:checkout_branch)
      subject.start(branch)
    end
  end
  
  context "#update" do
    it "updates" do
      Give::Repo.should_receive(:new).and_return(repo)
      repo.should_receive(:update)
      subject.update(branch, upstream_branch)
    end
  end
  
  context "#finish" do
    it "finishes" do
      Give::Repo.should_receive(:new).with(:branch => branch).and_return(repo)
      repo.should_receive(:push)
      Give::Project.should_receive(:new).with(owner, project).and_return(project)
      project.should_receive(:send_pull_request)
      subject.finish(owner, project, branch)
    end
  end
end

describe Give::Project do
  let(:owner)    { 'github_owner' }
  let(:title)    { 'give' }
  let(:github_login) { 'github_user' }
  let(:reference) { 'github_owner/give' }
  let(:request_title) { 'awesome feature' }
  let(:request_body) { 'is awesome' } 
  subject { Give::Project.new(owner, title) }
    
  before do
    Give::User.any_instance.stub(:github_login).and_return github_login
    Give::Project.any_instance.stub(:request_body).and_return request_body
    Give::Project.any_instance.stub(:request_title).and_return request_title
  end

  context "#new" do

    it "should have an owner" do
      subject.owner.should eq owner
    end 

    it "should have a title" do
      subject.title.should eq title
    end

    it "should have a target branch" do
       subject.target_branch.should eq 'master' 
    end

    it "has a reference" do
      subject.reference.should eq reference
    end

    it "should have a client" do
      subject.client.should be_a Octokit::Client
    end

    it "should have a user" do
      subject.user.should be_a Give::User
    end

  end

  context "#fork" do
  
    it "forks with octokit" do
      subject.client.should_receive(:fork!).with(subject.reference) 
      subject.should_receive(:git).with('clone git@github.com:github_user/give.git')
      subject.should_receive(:sh).with('cd give;git remote add upstream git://github.com/github_owner/give.git')
      subject.fork
    end
  end

  context "#send_pull_request" do
    let(:local_repo) { stub(:branch => 'my_awesome_feature') }
    let(:title) { 'title' }
    let(:body) { 'body' }
    let(:local_ref) { 'github_user:my_awesome_feature' }
    let(:target_branch) { 'master' }

    before do
      subject.stub(:title).and_return(title)
      subject.stub(:body).and_return(body)
    end
    it "sends a pull request with octokit" do
      subject.client.should_receive(:create_pull_request).
        with(subject.reference, target_branch, local_ref, request_title, request_body)

      subject.send_pull_request(local_repo)
    end
  end
end


describe Give::User do
  context "#new" do
    let(:github_login) { 'user' }
    let(:github_token) { 'supersecret' }
    let(:endpoint) { 'https://github.com' } 
    subject { Give::User.new }

    before do
      Give::User.any_instance.stub(:github_login).and_return github_login
      Give::User.any_instance.stub(:github_token).and_return github_token
    end

    it "should have a login" do
      subject.login.should eq github_login
    end

    it "should have a token" do
      subject.token.should eq github_token
    end

    it "should have an endpoint" do
      subject.endpoint.should eq endpoint
    end

    it "should configure Octokit" do
      Octokit.login.should eq github_login
      Octokit.token.should eq github_token
      Octokit.endpoint.should eq "https://github.com"
    end
  end
end

describe Give::Repo do

  let(:branch) { 'feature/my_awesome_feature' }
  let(:upstream_branch) { 'upstream_branch' }
  context "#new" do

    context "without a branch" do
      subject { Give::Repo.new }

      it "has master as the branch" do
        subject.branch.should eq :master
      end
    end

    context "with a branch" do
      subject { Give::Repo.new(:branch => branch) }
    
      it "has the branch" do
        subject.branch.should eq branch
      end
    end
    
    context "with an upstream branch" do

      subject { Give::Repo.new(:upstream_branch => upstream_branch) }

      it "has the upstream branch" do
        subject.upstream_branch.should eq upstream_branch
      end
    end
  end

  context "without an upstream branch" do

    subject { Give::Repo.new(:branch => branch) }

    it "has the upstream as master" do
      subject.upstream_branch.should eq :master
    end
  end

  context "#update" do
    subject { Give::Repo.new(:branch => branch, :upstream_branch => upstream_branch) }
   
    it "updates the branch" do
      subject.should_receive(:git).with('fetch upstream')
      subject.should_receive(:git).with('checkout upstream_branch') 
      subject.should_receive(:git).with('pull upstream upstream_branch') 
      subject.should_receive(:git).with("checkout #{branch}") 
      subject.should_receive(:git).with('rebase upstream_branch') 
      subject.update
    end
  end

  context "#branch" do
    subject { Give::Repo.new(:branch => branch) }
    it "creates a new branch" do
      subject.should_receive(:git).with("checkout -b #{branch}")
      subject.checkout_branch
    end
  end
  
  context "#push" do
    subject { Give::Repo.new(:branch => branch) }
    it "creates a new branch" do
      subject.should_receive(:git).with("push origin #{branch}")
      subject.push
    end
  end
end
