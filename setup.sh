#!/bin/sh

docker-compose run --rm web bundle install && \
docker-compose run --rm web bundle exec rake db:setup
