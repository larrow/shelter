#!/bin/sh

case "$1" in
  config )
    if [ -f "./config/env_file" ]
    then
      echo 'prepared.'
    else
      cd /tmp
      /prepare.sh $2
    fi
    ;;
  backend )
    exec bundle exec sidekiq
    ;;
  *)
    sleep 3
    bundle exec rake db:create db:migrate db:seed

    rm -f tmp/pids/server.pid
    exec rails s -p 3000 -b 0.0.0.0
esac

