class ServiceController < ApplicationController
  protect_from_forgery with: :null_session

  # ignore csrf params for registry callback
  skip_before_filter :verify_authenticity_token, :only => [:notifications]

  def notifications
    inner_service_auth do
      events = JSON.parse(request.body.read)['events']
      Rails.logger.debug "events: #{events}"
      RegistryEvent.transaction do
        events.each do |event|
          RegistryEvent.find_or_create_by(action: event['action'], repository: event['target']['repository'], original_id: event['id'], actor: event['actor']['name'], created_at: Time.parse(event['timestamp'])) unless event['target']['mediaType'] == 'application/octet-stream' # ignore blob notification
        end
      end
      render plain: ''
    end
  end

  def token
    head 401 and return unless Setting.allow_push
    authenticate_with_http_basic do |username, password|
      resource = User.find_by_username(username)
      sign_in :user, resource if resource&.valid_password? password
    end
    head 401 and return unless user_signed_in?

    render json: {token: Registry.new(user: current_user).token(params[:scope])}
  end

  private
  def inner_service_auth
    head 401 and return if ENV['SERVICE_TOKEN']!=request.headers['Authorization'].split(/ /).last
    yield
  end
end
