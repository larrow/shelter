class TagsController < ApplicationController
  before_action :process_params

  def index
    authorize! :read, @repository
    @tags = Kaminari.paginate_array(@repository.tags.reverse).page(params[:page]).per(10)
  end

  def destroy
    authorize! :write, @repository
    Registry.delete_tag(@repository.full_path, params[:id])
    Repository.sync_from_registry
    redirect_back fallback_location: namespace_repository_path(@namespace.name, @repository.name)
  end

  private
  def process_params
    @namespace = Namespace.find_by(name: params[:namespace_id])
    @repository = @namespace&.repositories&.find_by(name: params[:repository_id])

    redirect_to namespace_path(@namespace.name) unless @repository
  end
end
