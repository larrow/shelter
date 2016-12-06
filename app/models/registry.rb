module Registry
  include HTTParty
  base_uri 'http://proxy'
  RSA_PRIVATE_KEY = OpenSSL::PKey::RSA.new(File.read(File.join(Rails.root, 'config', 'private_key.pem')))

  def repositories
    get('/v2/_catalog', headers: headers_for_scope('registry:catalog:*'))['repositories']
  end

  def tags repository
    get("/v2/#{repository}/tags/list", headers: headers_for_scope("repository:#{repository}:pull"))['tags']||[]
  end

  def delete_tag(repository, tag)
    digest = manifests(repository, tag)[0]
    delete_manifests repository, digest
  end

  def delete_manifests(repository, reference)
    delete("/v2/#{repository}/manifests/#{reference}", headers: headers_for_scope("repository:#{repository}:*"))
  end

  def manifests(repository, reference)
    resp = get("/v2/#{repository}/manifests/#{reference}",
      headers: headers_for_scope("repository:#{repository}:pull", Accept: 'application/vnd.docker.distribution.manifest.v2+json'))
    [resp.headers['docker-content-digest'], resp]
  end

  def token(scope, sub=nil)
    payload = {
      iss: 'registry-token-issuer',
      sub: (sub || 'system-service'),
      aud: 'token-service',
      exp: 10.minutes.from_now.to_i,
      nbf: 1.minutes.ago.to_i,
      iat: Time.now.to_i,
      jti: SecureRandom.uuid,
      access: []
    }

    if scope
      scope_type, scope_name, scope_actions = scope.split(':')
      scope_actions = scope_actions.split(',')
      if sub.nil?
        payload[:access] << {
          type: scope_type,
          name: scope_name,
          actions: scope_actions
        }
      else
        case scope_type
        when 'repository'
          namespace_name = scope_name.split('/').length == 2 ? scope_name.split('/').first : 'library'
          repository_name = scope_name.split('/').last

          authorized_actions = yield namespace_name, repository_name if block_given?
          payload[:access] << {
            type: scope_type,
            name: scope_name,
            actions: authorized_actions
          }
        end
      end
    end

    Rails.logger.debug "payload: #{payload}"
    header = {
      kid: Base32.encode(Digest::SHA256.digest(RSA_PRIVATE_KEY.public_key.to_der)[0...30]).scan(/.{4}/).join(':')
    }

    JWT.encode payload, RSA_PRIVATE_KEY, 'RS256', header
  end

  def headers_for_scope(scope, other_headers = {})
    { 'Authorization': 'Bearer ' + token(scope) }.merge(other_headers)
  end

  module_function :repositories, :tags, :delete_tag, :delete_manifests, :token, :manifests, :headers_for_scope
end
