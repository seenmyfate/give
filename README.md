## give
--------------
give makes contributing to open source projects on Github just a little easier, by wrapping some simple commands around a common workflow.


[![Build
Status](https://secure.travis-ci.org/seenmyfate/give.png)](http://travis-ci.org/seenmyfate/give)

### Installation

	gem install give

You must have set your git username and api token, if you not please follow [these instructions](http://help.github.com/set-your-user-name-email-and-github-token/)

### Usage

You will need the name of the GitHub user, and the repository name for the project in question.  In this example we'll use the give gem itself.

First up, fork the project and check out your new copy of the repo with the `give setup` command.

	give setup seenmyfate give
	
Next `cd` into your newly created git repo, and create a feature branch to work in.

	give start feature/my_awesome_feature

Commit away as usual, but be sure to keep your feature branch up to date with any new changes added to the forked repo by running `give update`

	give update feature/my_awesome_feature

Give assumes you will be contributing to the 'master' branch of the project you have forked.  If this is not case, add the name of the branch as a second argument when updating

  give update feature/my_awesome_feature develop


When the work is complete, push up the branch and send a pull request with `give finish`

	give finish seenmyfate give feature/my_awesome_feature

You will be prompted to enter a title and body for the pull request.

### Roadmap
Any help with the following would be appreciated, but I'd also love to hear
any ideas about improving this project.

* Windows support
* Twitter integration
* Remove dependency on Octokit

### Contributing to give
-----------------------------------

* Try using give as outlined above, this will help to identify possible
  workflow improvements
* Be sure to run the tests, and test against 1.8 and 1.9
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

#### Copyright

Copyright (c) 2011 Tom Clements. See LICENSE.txt for
further details.

