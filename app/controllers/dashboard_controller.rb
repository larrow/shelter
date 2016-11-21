class DashboardController < ApplicationController
  before_action :authenticate_user!
  def index
    @authorized_groups = current_user.namespaces
    @repositories = current_user.personal_namespace.repositories.order(updated_at: :desc).page(params[:page])
  end
end
