#!/bin/bash

set -e

gem install bundler

cd common
bundle install --path=vendor/cache

cd ../user-api/

bundle config --local local.candidatexyz-common ../common/
bundle install --path=vendor/cache

bundle exec rake db:create
bundle exec rake db:schema:load
bundle exec rake db:seed

cd ../

bundle config --local local.candidatexyz-common common/
bundle install --path=vendor/cache

bundle exec rake db:create
bundle exec rake db:schema:load
bundle exec rake db:seed
