#!/bin/sh

if [ "$1" = "backend" ]
then
  sleep 5
  exec bundle exec sidekiq
else
  sleep 3
  bundle exec rake db:create db:migrate db:seed
  exec rails s -p 3000 -b 0.0.0.0
fi
