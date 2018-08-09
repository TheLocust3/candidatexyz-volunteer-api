#!/bin/bash

set -e

gem install bundler

GIT_SSH_COMMAND="ssh -i ${SSH_KEY}" git clone git@github.com:TheLocust3/candidatexyz-common.git common/

bundle config --local local.candidatexyz-common common/
bundle install

bundle exec rails test
