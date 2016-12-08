ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile
require 'yaml'
require_relative '../lib/sync_worker'

schedule_file = File.expand_path("./schedule.yml", __dir__)
puts YAML.load_file schedule_file
Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)

Larrow::Registry.base_uri 'http://proxy'
SyncWorker.base_uri 'http://proxy'
