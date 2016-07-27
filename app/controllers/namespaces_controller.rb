class NamespacesController < ApplicationController
  before_action :process_params

  def teams
  end

  def settings
  end

  def create
  end

  def new
  end

  def edit
  end

  def destroy
  end

  def show
    @repositories = @namespace.repositories
    @repositories = @repositories.where(is_public: true) unless user_signed_in? && @namespace.user == current_user
  end

  private

  def process_params
    @namespace = Namespace.find_by!(name: params[:id])
  end
end
