class RegistrySyncWorker
  include Sidekiq::Worker

  def perform
    Repository.sync_from_registry
  end
end
