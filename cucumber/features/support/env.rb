require 'bundler'
Bundler.require :default

require_relative 'registry'
require_relative 'web_support'
require_relative 'user_support'
require_relative 'registry_support'
include UserSupport
include RegistrySupport

ORIGINAL_BLOB1 = File.read('features/fixtures/blob1')
ORIGINAL_BLOB2 = File.read('features/fixtures/blob2')
ORIGINAL_DIGEST1 = File.read('features/fixtures/digest1')
ORIGINAL_DIGEST2 = File.read('features/fixtures/digest2')
ORIGINAL_MANIFEST_LIBRARY_TEST1 = File.read('features/fixtures/manifest_library_test1')
ORIGINAL_MANIFEST_TESTORG_TEST1 = File.read('features/fixtures/manifest_testorg_test1')

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
