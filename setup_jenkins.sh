#!/bin/bash

set -e

gem install bundler

cd common
bundle install

cd ../user-api/

bundle config --local local.candidatexyz-common ../common/
bundle install

bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed

cd ../

bundle config --local local.candidatexyz-common common/
bundle install

bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed
