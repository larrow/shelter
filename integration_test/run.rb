#!/usr/bin/env ruby

require 'open-uri'
require 'timeout'


def check_once
  Timeout.timeout(2) do
      open('http://proxy/')
  end
rescue OpenURI::HTTPError, Errno::ECONNREFUSED => e
  puts "."
  sleep 1.5
  false
rescue Timeout::Error
  false
end

$stdout.sync = true

puts 'wait for the service to be ready'

30.times do
  exec 'rspec' if check_once
end

exit 1

