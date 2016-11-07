require 'docker-api'
require 'socket'

module Registry
  def init
    return if @images

    %w{v1 v2 v3}.each do |tag|
      File.open("features/fixtures/hello-world_#{tag}.tar",'rb') do |f|
        Docker::Image.load(f)
      end
    end

    @images = {}
    # use proxy directly will get wrong ipaddress
    @addr = IPSocket::getaddress 'proxy'

    Docker::Image.all.each do |img|
      tag = img.info['RepoTags'].first
      if tag =~ /hello-world:(v.)/
        @images.update $1 => img
      end
    end
    @images
  end

  def login_as user
    addr = IPSocket::getaddress 'proxy' # use proxy directly will get wrong ipaddress
    Docker.authenticate!(username: user[:login],
                         password: user[:password],
                         serveraddress: addr)
  end

  def push(image, tag)
    img = @images[tag.to_s]
    id = img.id

    # docker tag <old_tag> <addr+image+tag>
    img.tag repo: "#{@addr}/#{image}", tag: tag
    # docker push <add+image+tag>
    img.push nil, repo_tag: "#{@addr}/#{image}:#{tag}"
    # docker rmi <add+image+tag>
    img.remove name: "#{@addr}/#{image}:#{tag}"
    # reload image object
    @images[tag.to_s] = Docker::Image.get id
  end

  def images; @images end
  module_function :init, :login_as, :push, :images
end

Registry.init

