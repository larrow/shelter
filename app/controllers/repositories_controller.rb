class RepositoriesController < ApplicationController
  before_action :process_params
  before_action :authenticate_user!, only: [:new, :update, :destroy]

  def settings
  end

  def collaborators
  end

  def show
  end

  def update
  end

  def destroy
  end

  def toggle_publicity
    @repository.update_attribute(:is_public, params[:is_public] == 'true')
    redirect_to namespace_repository_path(@namespace.name, @repository.name)
  end

  private

  def process_params
    @namespace = Namespace.find_by(name: params[:namespace_id])
    @repository = @namespace&.repositories&.find_by(name: params[:id])
  end
end
