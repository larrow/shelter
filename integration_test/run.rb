#!/usr/bin/env ruby

require 'net/ping'

def check_once
  Net::Ping::HTTP.new('localhost').ping.tap do |ok|
    if not ok
      puts "."
      sleep 1.5
    end
  end
end

$stdout.sync = true

puts 'wait for the service to be ready'

30.times do
  exec 'cucumber' if check_once
end

exit 1

