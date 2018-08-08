#!/bin/bash

set -e

echo $SSH_KEY > key

path=pwd

rm /home/ubuntu/.ssh/config || true
echo "Host github.com
  IdentityFile ${path}/key" > /home/ubuntu/.ssh/config

gem install bundler
bundle install

bundle exec rails test

rm key
