class TagsController < ApplicationController
  before_action :process_params

  def index
    authorize! :read, @repository
    @tags = Kaminari.paginate_array(@repository.tags.reverse).page(params[:page]).per(10)
  end

  def destroy
    authorize! :write, @repository
    if @repository.remove_tag(params[:id])
      redirect_to namespace_path(@namespace.name), notice: t('.repository_deleted')
    else
      redirect_to namespace_repository_path(@namespace.name, @repository.name)
    end
  end

  private
  def process_params
    @namespace = Namespace.find_by(name: params[:namespace_id])
    @repository = @namespace&.repositories&.find_by(name: params[:repository_id])

    head 404 and return if @repository.nil?
  end
end
