class RegistryEventJob < ApplicationJob
  queue_as :default

  def perform(events)
    events.each do |event|
      repository = event['target']['repository']
      case event['action']
      when 'push'
        repo = Repository.find_or_create_by_full_name repository
        tag = repo.tags.find_or_create_by name: event['target']['tag']
        tag.update digest: event['target']['digest']
        RepositoryChannel.broadcast_to(repo, action: 'push') if repo
      when 'pull'
        Repository.find_or_create_by_full_name(repository).increment! :pull_count unless event['actor']['name'] == 'system-service'
      when 'delete'
        repo = Repository.find_by_full_name(repository)
        repo.delete if repo&.tags&.empty?
      end

    end
  end
end
