require 'json'
require 'rest-client'
require 'pry'

class Registry
  # example: https://myuser:mypass@my.registy.corp.com
  def initialize(url)
    uri = URI.parse url
    parts = URI.split url
    @full_url = url
    @registry = "%s://%s:%s" % [parts[0], parts[2], parts[3]]
    @user = uri.user
    @password = uri.password
    # RestClient.proxy = "http://localhost:8888/"
  end

  def token(scope)
    uri = URI.parse @full_url
    uri.path = "/service/token"
    response = RestClient.get uri.to_s, {params: {service: 'token-service', scope: scope}}
    JSON.parse(response.body)['token']
  end

  def push_manifest(image, reference, content)
    uri = URI.parse @registry
    uri.path = "/v2/#{image}/manifests/#{reference}"
    push_token = token("repository:#{image}:pull,push")
    response = RestClient.put uri.to_s, content, {Authorization: "Bearer #{push_token}", content_type: 'application/vnd.docker.distribution.manifest.v1+json'}
  end

  # return: blob location
  def push_blob(image, content)
    uri = URI.parse @registry
    uri.path = "/v2/#{image}/blobs/uploads/"
    push_token = token("repository:#{image}:pull,push")
    response = RestClient.post uri.to_s, nil, {Authorization: "Bearer #{push_token}"}
    location = response.headers[:location]
    uri = URI.parse location
    uri.query += "&digest=#{digest(content).sub(':', '%3A')}"
    push_token = token("repository:#{image}:pull,push")
    response = RestClient.put uri.to_s, content, {Authorization: "Bearer #{push_token}", content_type: 'application/octet-stream'}
    response.headers[:docker_content_digest] if response.code == 201
  end

  def pull_manifest(image, reference)
    uri = URI.parse @registry
    uri.path = "/v2/#{image}/manifests/#{reference}"
    pull_token = token("repository:#{image}:pull")
    res = RestClient.get uri.to_s, {Authorization: "Bearer #{pull_token}", accept: 'application/vnd.docker.distribution.manifest.v1+json'}
    res.body
  end

  def pull_blob(image, digest)
    uri = URI.parse @registry
    uri.path = "/v2/#{image}/blobs/#{digest}"
    pull_token = token("repository:#{image}:pull")
    res = RestClient.get uri.to_s, {Authorization: "Bearer #{pull_token}"}
    res.body
  end

  def digest(content)
    "sha256:" + Digest::SHA256.hexdigest(content)
  end
end
