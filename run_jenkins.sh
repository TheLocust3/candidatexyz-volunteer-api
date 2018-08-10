#!/bin/bash

set -e

echo Setting up

mkdir ~/.bundle
touch ~/.bundle/config
echo BUNDLE_PATH: vendor/bundle > ~/.bundle/config

gem install bundler

cd common/
bundle install --path vendor/bundle

cd ../user-api/

bundle config --local local.candidatexyz-common ../common/
bundle install --path vendor/bundle

bundle exec rake db:create
bundle exec rake db:schema:load
bundle exec rake db:seed

bundle exec puma -b tcp://127.0.0.1:3003 &

cd ../

bundle config --local local.candidatexyz-common common/
bundle install --path vendor/bundle

bundle exec rake db:create
bundle exec rake db:schema:load
bundle exec rake db:seed

# idk but rails wants it
echo fs.inotify.max_user_watches=524288 | tee -a /etc/sysctl.conf && sysctl -p

echo Running tests

bundle exec rails test
