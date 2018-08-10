#!/bin/bash

set -e

mkdir ~/.bundle
touch ~/.bundle/config
echo BUNDLE_PATH: ~/.bundle/gems > ~/.bundle/config

gem install bundler

cd common
bundle install --path ~/.bundle/gems

cd ../user-api/

bundle config --local local.candidatexyz-common ../common/
bundle install --path ~/.bundle/gems

bundle exec rake db:create
bundle exec rake db:schema:load
bundle exec rake db:seed

bundle exec puma -b tcp://127.0.0.1:3003 &

cd ../

bundle config --local local.candidatexyz-common common/
bundle install --path ~/.bundle/gems

bundle exec rake db:create
bundle exec rake db:schema:load
bundle exec rake db:seed
