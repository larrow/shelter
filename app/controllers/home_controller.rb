class HomeController < ApplicationController
  def index
    @user = User.new
    redirect_to dashboard_index_path if user_signed_in?
  end
end
