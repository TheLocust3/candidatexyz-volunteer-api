#!/bin/bash

set -e

gem install bundler

bundle config --local local.candidatexyz-common common/
bundle pack
bundle install --path vendor/cache
