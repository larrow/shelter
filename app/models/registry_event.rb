class RegistryEvent < ApplicationRecord
  validates :original_id, presence: true, uniqueness: true
  after_create :sync_event_to_entity
  def sync_event_to_entity
    case self.action
    when 'push'
      Repository.transaction do
        repo = Repository.find_or_create_by_repo_name self.repository
        RepositoryChannel.broadcast_to(repo, action: 'push') if repo
      end
    when 'pull'
      Repository.find_or_create_by_repo_name(self.repository).increment! :pull_count unless self.actor == 'system-service'
    end
  end
end
