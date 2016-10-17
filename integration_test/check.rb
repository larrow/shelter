#!/usr/bin/env ruby

require 'open-uri'
require 'timeout'


def check_once
  Timeout.timeout(2) do
      open('http://proxy/')
  end
rescue OpenURI::HTTPError, Errno::ECONNREFUSED => e
  puts "#{e}...wait and try again"
  sleep 2
  false
rescue Timeout::Error
  false
end

$stdout.sync = true

10.times do
  exit 0 if check_once
end

exit 1

