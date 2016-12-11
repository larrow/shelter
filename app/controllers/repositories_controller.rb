class RepositoriesController < ApplicationController
  before_action :process_params
  before_action :authenticate_user!, except: :show

  def show
    authorize! :read, @repository
  end

  def update
    authorize! :write, @repository
    @repository.update!(params.require(:repository).permit(:description))
    redirect_to namespace_repository_path(@namespace.name, @repository.name)
  end

  def destroy
    authorize! :write, @repository
    @repository.destroy
    redirect_to namespace_path(@repository.namespace.name), notice: t('.repository_deleted')
  end

  def toggle_publicity
    authorize! :write, @repository
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
    head 404 and return if @namespace.nil?

    @repository = @namespace.repositories.find_by(name: params[:id])
    head 404 and return if @repository.nil?
  end
end
