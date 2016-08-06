class Admin::UsersController < Admin::ApplicationController
  # GET /admin/users
  def index
    @users = User.order(:id).page params[:page]
  end

  def update
    User.find_by(id: params[:id])&.update(params.require(:user).permit(:admin))
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create(params.require(:user).permit(:username, :email, :password, :password_confirmation))
    redirect_to admin_users_path
  end
end
