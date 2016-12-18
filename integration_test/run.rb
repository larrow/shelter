#!/usr/bin/env ruby

require 'net/ping'

$stdout.sync = true

def check_server
  30.times do
    return if Net::Ping::HTTP.new('localhost').ping?
    puts "."
    sleep 1.5
  end
  fail 'cannot connect to server'
end

puts 'wait for the service to be ready'
check_server
exec 'cucumber'

