#!/bin/bash

set -e

rm /home/ubuntu/.ssh/config || true

touch /home/ubuntu/.ssh/config
echo "Host github.com
  IdentityFile ${$SSH_KEY}" > /home/ubuntu/.ssh/config

gem install bundler
bundle install

bundle exec rails test
