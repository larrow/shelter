class DashboardController < ApplicationController
  before_action :authenticate_user!
  def index
    @repositories = current_user.namespace.repositories.order(updated_at: :desc).page(params[:page])
  end
end
