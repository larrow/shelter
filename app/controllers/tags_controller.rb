class TagsController < ApplicationController
  before_action :process_params

  def index
    @tags = @repository.tags
  end

  def destroy
    Registry.new(is_system: true, repository: @repository.full_path).delete_tag(params[:id])
    redirect_back fallback_location: namespace_repository_path(@namespace.name, @repository.name)
  end

  private
  def process_params
    @namespace = Namespace.find_by(name: params[:namespace_id])
    @repository = @namespace&.repositories&.find_by(name: params[:repository_id])
  end
end
