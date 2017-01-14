#!/usr/bin/env ruby
require 'net/ping'

def check_db
  30.times do
    return if Net::Ping::TCP.new('db', 5432).ping?
    sleep 1.5
  end
  fail 'cannot connect to db'
end

case ARGV[0]
when 'config'
  if File.exist? "./config/env_file"
    puts 'prepared.'
  else
    cmd = ["cd /tmp",
     "/prepare.sh #{ARGV[1]}",
     "(cp /usr/src/app/deploy/docker-compose.yml . || echo 'compose file exist!')"
    ].join(' && ')
    system cmd
  end
else
  check_db
  system 'bundle exec rake db:create db:migrate db:seed'
  system 'rm -rf tmp/pids/server.pid'
  exec 'rails s -p 3000 -b 0.0.0.0'
end

