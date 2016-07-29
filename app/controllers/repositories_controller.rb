class RepositoriesController < ApplicationController
  before_action :process_params
  before_action :authenticate_user!, only: [:new, :update, :destroy]

  def show
    authorize! :read, @repository
  end

  def update
    authorize! :push, @repository
    @repository.update!(params.require(:repository).permit(:description))
    redirect_to namespace_repository_path(@namespace.name, @repository.name)
  end

  def toggle_publicity
    authorize! :update, @repository
    @repository.update_attribute(:is_public, params[:is_public] == 'true')
    redirect_to namespace_repository_path(@namespace.name, @repository.name)
  end

  def edit_description
    respond_to do |format|
      format.js {}
    end
  end

  private

  def process_params
    @namespace = Namespace.find_by(name: params[:namespace_id])
    @repository = @namespace&.repositories&.find_by(name: params[:id])
  end
end
