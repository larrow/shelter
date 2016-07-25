class DashboardController < ApplicationController
  before_action :authenticate_user!
  def index
    @repositories = current_user.namespace.repositories
  end
end
