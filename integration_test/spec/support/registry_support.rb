module RegistrySupport
  # user: expects :login and :password
  def registry_for(user)
    Registry.new("http://#{user[:login]}:#{user[:password]}@proxy/")
  end
end
