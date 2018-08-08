#!/bin/bash

set -e

env

gem install bundler
bundle install

bundle exec rails test
