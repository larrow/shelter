class RepositoriesController < ApplicationController
  before_action :process_params

  def settings
  end

  def collaborators
  end

  def new
  end

  def show
  end

  def update
  end

  def destroy
  end

  private

  def process_params
    @namespace = Namespace.find_by(name: params[:namespace_id])
    @repository = @namespace&.repositories&.find_by(name: params[:id])
  end
end
