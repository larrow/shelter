class NamespacesController < ApplicationController
  before_action :process_params, except: [:create, :new]
  before_action :authenticate_user!, only: [:create, :new]

  def create
    redirect_back fallback_location: root_path, alert: t('.exists') and return if Namespace.find_by(name: params[:group][:name])
    @group = current_user.create_group(params[:group][:name])
    redirect_to namespace_path(@group.name)
  end

  def new
    @group = Group.new
  end

  def show
    authorize! :read, @namespace
    @repositories = @namespace.repositories
    @repositories = @repositories.where(is_public: true) unless user_signed_in? && can?(:update, @namespace)
  end

  private

  def process_params
    @namespace = Namespace.find_by!(name: params[:id])
  end
end
