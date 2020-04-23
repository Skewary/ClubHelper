#!/usr/bin/env bash

git pull origin master && \
bundle install && \
rails db:migrate RAILS_ENV=production && \
./start_production.sh
