require 'sidekiq'
require 'sidekiq/cron'
require 'httparty'
require 'larrow/registry'

class SyncWorker
  include Sidekiq::Worker
  include HTTParty
  include Larrow

  def perform
    # get repositories with structure
    #
    # sample:
    # {
    #   library => [
    #     'library/hello',
    #     'library/hllo',
    #     'library/helo',
    #   ]
    # }
    namespaces = Registry.repositories.
      # no tags means repo should not be exist
      select{|repo| not Registry.tags(repo).empty?}.
      # group by namespace
      group_by{|repo| repo.split('/').length == 2 ? repo.split('/')[0] : 'library' }

    # change values to simple repository name
    namespaces.each do |k,v|
      simple_repo_names = v.map{|repo| repo.split('/').last}
      namespaces[k] = simple_repo_names
    end

    puts "namespaces: #{namespaces}"
    self.class.put("/service/sync",
                   body: namespaces.to_json,
                   headers: {'Content-Type' => 'application/json', 'Authorization' => "Bearer #{ENV['SERVICE_TOKEN']}"}
                  )
  end
end
