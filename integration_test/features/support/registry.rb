require 'docker-api'
require 'socket'

module Registry
  def init
    return if @local_imgs

    %w{v1 v2 v3}.each do |tag|
      File.open("features/fixtures/hello-world_#{tag}.tar",'rb') do |f|
        Docker::Image.load(f)
      end
    end

    @local_imgs = {}
    # use proxy directly will get wrong ipaddress
    @addr = ENV['remote_registry'] || 'localhost'

    Docker::Image.all.each do |img|
      tag = img.info['RepoTags'].first
      if tag =~ /hello-world:(v.)/
        @local_imgs.update $1 => img
      end
    end
    @local_imgs
  end

  def login_as user
    Docker.authenticate!(username: user[:login],
                         password: user[:password],
                         serveraddress: @addr)
  end

  def push(image, tag)
    img = @local_imgs[tag.to_s]
    id = img.id

    # docker tag <old_tag> <addr+image+tag>
    img.tag repo: "#{@addr}/#{image}", tag: tag
    # docker push <add+image+tag>
    img.push nil, repo_tag: "#{@addr}/#{image}:#{tag}"
    # docker rmi <add+image+tag>
    img.remove name: "#{@addr}/#{image}:#{tag}"
    # reload image object
    @local_imgs[tag.to_s] = Docker::Image.get id
  end

  def local_imgs; @local_imgs end
  module_function :init, :login_as, :push, :local_imgs
end

Registry.init

