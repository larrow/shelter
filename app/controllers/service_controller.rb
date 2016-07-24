class ServiceController < ApplicationController
  protect_from_forgery with: :null_session

  def notifications
    events = JSON.parse(request.body.read)['events']
    events.each do |event|
      RegistryEvent.find_or_create_by(action: event['action'], repository: event['target']['repository'], original_id: event['id'], actor: event['actor']['name'], created_at: Time.parse(event['timestamp']))
    end

    render plain: ''
  end

  def token
    authenticate_with_http_basic do |username, password|
      resource = User.find_by_username(username)
      sign_in :user, resource if resource&.valid_password? password
    end
    head 401 and return unless user_signed_in?

    render json: {token: Registry.new(user: current_user).token(params[:scope])}
  end
end
