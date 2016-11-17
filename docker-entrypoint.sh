#!/bin/sh

case "$1" in
  config )
    if [ -f ".env" ]
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

    exec rails s -p 3000 -b 0.0.0.0
esac

