class DashboardController < ApplicationController
  before_action :authenticate_user!
  def index
    @authorized_groups = current_user.namespaces
  end
end
