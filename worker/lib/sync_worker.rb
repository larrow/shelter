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
    #     [ 'library/hello', ['v1','v2'] ],
    #     [ 'library/hllo', ['v1','v2'] ],
    #     [ 'library/helo', ['v1','v2'] ]
    #   ]
    # }
    namespaces = Registry.repositories.
      # no tags means repo should not be exist
      map{|repo| [repo, Registry.tags(repo)]}.
      select{|(_repo, tags)| not tags.empty?}.
      # group by namespace
      group_by{|(repo, _tags)| repo.split('/').length == 2 ? repo.split('/')[0] : 'library' }

    # change values to simple repository name
    namespaces.map do |k,v|
      repos = v.map{|(repo, tags)| [repo.split('/').last, tags]}

      body = { k => Hash[repos] }
      self.class.put("/service/sync",
                     body: body.to_json,
                     headers: {'Content-Type' => 'application/json', 'Authorization' => "Bearer #{ENV['SERVICE_TOKEN']}"}
                    )
    end
  end
end
