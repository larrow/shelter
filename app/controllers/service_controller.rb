class ServiceController < ApplicationController
  def notifications
  end

  def token
    if user = authenticate_with_http_basic { |username, password| User.login(username, password) }
    end
  end
end
