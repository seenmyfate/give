FROM debian:9.5-slim
FROM ruby:2.6

LABEL "com.github.actions.name"="Rake"
LABEL "com.github.actions.description"="Runs the application's default Rake task"
LABEL "com.github.actions.icon"="mic"
LABEL "com.github.actions.color"="purple"

LABEL "repository"="http://github.com/seenmyfate/give"
LABEL "homepage"="http://github.com/actions"
LABEL "maintainer"="Tom <seenmyfate@gmail.com>"

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
