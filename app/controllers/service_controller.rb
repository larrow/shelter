class ServiceController < ApplicationController
  def notifications
  end

  def token
    authenticate_with_http_basic do |username, password|
      resource = User.find_by_username(username)
      sign_in :user, resource if resource&.valid_password? password
    end
    head 401 and return unless user_signed_in?

    rsa_private_key = OpenSSL::PKey::RSA.new(File.read(File.join(Rails.root, 'config', 'private_key.pem')))

    payload = {
      iss: 'registry-token-issuer',
      sub: (current_user&.username || ''),
      aud: params[:service],
      exp: 10.minutes.from_now.to_i,
      nbf: 1.minutes.ago.to_i,
      iat: Time.now.to_i,
      jti: SecureRandom.uuid,
      access: [
        # {
        #   type: 'repository',
        #   name: 'qinix/qinix',
        #   actions: ['pull', 'push']
        # },
        # {
        #   type: 'registry',
        #   name: 'catalog',
        #   actions: ['*']
        # }
      ]
    }

    header = {
      kid: Base32.encode(Digest::SHA256.digest(rsa_private_key.public_key.to_der)[0...30]).scan(/.{4}/).join(':')
    }

    token = JWT.encode payload, rsa_private_key, 'RS256', header
    render json: {token: token}
  end
end
