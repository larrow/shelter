class DashboardController < ApplicationController
  before_action :authenticate_user!
  def index
    @repositories = current_user.personal_repositories.order(updated_at: :desc).page(params[:page])
  end
end
