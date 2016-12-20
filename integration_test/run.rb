#!/usr/bin/env ruby

require 'net/ping'

def check_server
  30.times do
    return if Net::Ping::HTTP.new('proxy').ping?
    sleep 1.5
  end
  fail 'cannot connect to server'
end

check_server
exec 'cucumber'

