#!/usr/bin/env bash
# exit on error
set -o errexit

chmod a+x bin/render-build.sh

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails