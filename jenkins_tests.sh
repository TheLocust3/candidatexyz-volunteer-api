#!/bin/bash

set -e

gem install bundler

bundle config --local local.candidatexyz-common common/
bundle install

bundle exec rails test
