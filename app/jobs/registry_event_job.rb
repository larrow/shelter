class RegistryEventJob < ApplicationJob
  queue_as :default

  def perform(events)
    events.each do |event|
      next if event['target']['mediaType'] == 'application/octet-stream' # ignore blob notification

      repository = event['target']['repository']
      case event['action']
      when 'push'
        repo = Repository.find_or_create_by_repo_name repository
        tag = repo.tags.find_or_create_by name: event['target']['tag']
        tag.update digest: event['target']['digest']
        RepositoryChannel.broadcast_to(repo, action: 'push') if repo
      when 'pull'
        Repository.find_or_create_by_repo_name(repository).increment! :pull_count unless self.actor == 'system-service'
      when 'delete'
        repo = Repository.find_or_create_by_repo_name(repository)
        repo.try_to_delete
      end

    end
  end
end
