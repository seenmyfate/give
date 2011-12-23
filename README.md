## give
--------------
The aim of Give is to make contributing to open source projects on Github just that bit easier, by wrapping some simple commands around a common workflow.

### Installation

	gem install give

You must have set your git username and api token, if you not please follow [these instructions](http://help.github.com/set-your-user-name-email-and-github-token/)

### Usage

You will need the name of the GitHub user, and the repository name for the project in question.  In this example we'll the give gem itself.

First up, fork the project and check out your new copy of the repo with the `give setup` command.

	give setup seenmyfate give
	
Next, create a feature branch to work in.

	give start feature/my_awesome_feature

Commit away as usual, but be sure to keep your feature branch up to date with any new changes added to the forked repo by running `give update`

	give update feature/my_awesome_feature

When the work is complete, push up the branch and send a pull request with `give finish`

	give finish seenmyfate give feature/my_awesome_feature

You will be prompted to enter a title and body for the pull request.


### Contributing to give
-----------------------------------

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

#### Copyright

Copyright (c) 2011 Tom Clements. See LICENSE.txt for
further details.

