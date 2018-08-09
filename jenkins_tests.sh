#!/bin/bash

set -e

ls /home
ls -a ~

rm ~/.ssh/config || true

touch ~/.ssh/config
echo "Host github.com
  IdentityFile ${$SSH_KEY}" > ~/.ssh/config

gem install bundler
bundle install

bundle exec rails test
