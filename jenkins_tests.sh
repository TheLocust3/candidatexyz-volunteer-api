#!/bin/bash

set -e

echo "Host github.com
  IdentityFile ${SSH_KEY}" > /etc/ssh/ssh_config

gem install bundler

git clone git@github.com:TheLocust3/candidatexyz-common.git common/

bundle config --local local.candidatexyz-common common/
bundle install

bundle exec rails test
