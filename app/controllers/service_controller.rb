class ServiceController < ApplicationController
  protect_from_forgery with: :null_session

  # ignore csrf params for registry callback
  skip_before_filter :verify_authenticity_token, :only => [:notifications, :sync]

  def notifications
    inner_service_auth do
      events = JSON.parse(request.body.read)['events']
      Rails.logger.debug "events: #{events}"
      RegistryEventJob.perform_later events
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
      if namespace
        repository = namespace.repositories.where(name: repository_name).first_or_initialize

        authorized_actions = []
        authorized_actions << 'pull' if current_user.can? :pull, repository
        authorized_actions += ['*', 'push'] if current_user.can? :push, repository
        authorized_actions
      else
        Rails.logger.debug "nil namespace(#{namespace_name}): #{params[:scope]}"
        []
      end
    end

    render json: {token: token}
  end

  def sync
    inner_service_auth do
      namespaces = JSON.parse(request.body.read)
      puts "namespaces: #{namespaces}"

      Namespace.find_each do |namespace|
        namespace.update_repositories namespaces[namespace]
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
