#!/bin/bash

set -e

echo "Host github.com
  IdentityFile ${$SSH_KEY}" > /etc/ssh/ssh_config

gem install bundler
bundle install

bundle exec rails test
