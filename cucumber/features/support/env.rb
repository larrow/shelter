require 'bundler'
Bundler.require :default

require_relative 'registry'
require_relative 'user_support'
require_relative 'registry_support'
include UserSupport
include RegistrySupport

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
