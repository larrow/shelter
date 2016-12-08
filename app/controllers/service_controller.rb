class ServiceController < ApplicationController
  protect_from_forgery with: :null_session

  # ignore csrf params for registry callback
  skip_before_filter :verify_authenticity_token, :only => [:notifications, :sync]

  def notifications
    inner_service_auth do
      events = JSON.parse(request.body.read)['events']
      Rails.logger.debug "events: #{events}"
      RegistryEvent.transaction do
        events.each do |event|
          RegistryEvent.find_or_create_by(action: event['action'], repository: event['target']['repository'], original_id: event['id'], actor: event['actor']['name'], created_at: Time.parse(event['timestamp'])) unless event['target']['mediaType'] == 'application/octet-stream' # ignore blob notification
        end
      end
    end
  end

  def token
    head 401 and return unless Setting.allow_push
    authenticate_with_http_basic do |username, password|
      resource = User.find_by_username(username)
      sign_in :user, resource if resource&.valid_password? password
    end
    head 401 and return unless user_signed_in?

    scope = params[:scope]
    sub   = current_user.username

    token = Registry.token scope, sub do |namespace_name, repository_name|
      namespace = Namespace.find_by(name: namespace_name)
      repository = namespace&.repositories.where(name: repository_name).first_or_initialize

      authorized_actions = []
      authorized_actions << 'pull' if current_user.can? :pull, repository
      authorized_actions += ['*', 'push'] if current_user.can? :push, repository
      authorized_actions
    end

    render json: {token: token}
  end

  def sync
    inner_service_auth do
      JSON.parse(request.body.read).each do |namespace_name, repo_hash|
        namespace = Namespace.find_by(name: namespace_name)
        if namespace
          repositories = namespace.repositories
          repo_names = repo_hash.keys

          # destroy repo which is not exist.
          repositories.each do |r|
            if repo_names.include?(r.name)
              Rails.logger.debug "service - destroy repo: #{r.name}"
              r.destroy
            end
          end

          # create repo which is not insert to db
          (repo_names - repositories.map(&:name)).each do |repo_name|
            Rails.logger.debug "service - create repo: #{repo_name}"
            namespace.repositories.create name: repo_name
          end
        end
      end
    end
  end

  private
  def inner_service_auth
    head 401 and return if ENV['SERVICE_TOKEN']!=request.headers['Authorization'].split(/ /).last
    yield
    render plain: ''
  end
end
