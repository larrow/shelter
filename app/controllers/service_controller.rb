class ServiceController < ApplicationController
  def notifications
  end

  def token
    # if user = authenticate_with_http_basic { |username, password| User.login(username, password) }
    # end
    rsa_private_key = OpenSSL::PKey::RSA.new(File.read(File.join(Rails.root, 'config', 'private_key.pem')))

    username = 'qinix'
    payload = {
      iss: 'registry-token-issuer',
      sub: username,
      aud: params[:service],
      exp: 10.minutes.from_now.to_i,
      nbf: 1.minutes.ago.to_i,
      iat: Time.now.to_i,
      jti: SecureRandom.uuid,
      access: [
        {
          type: 'repository',
          name: 'qinix/qinix',
          actions: ['pull', 'push']
        },
        {
          type: 'registry',
          name: 'catalog',
          actions: ['*']
        }
      ]
    }

    header = {
      kid: Base32.encode(Digest::SHA256.digest(rsa_private_key.public_key.to_der)[0...30]).scan(/.{4}/).join(':')
    }

    token = JWT.encode payload, rsa_private_key, 'RS256', header
    render json: {token: token}
  end
end
