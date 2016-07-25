class RepositoriesController < ApplicationController
  before_action :process_params
  before_filter :authenticate_user!, only: [:new, :update, :destroy]

  def settings
  end

  def collaborators
  end

  def new
    @repository = @namespace.repositories.new
  end

  def create
    @repository = @namespace.repositories.create(name: params[:repository][:name], description: params[:repository][:description].empty? ? nil : params[:repository][:description], is_public: params[:repository][:is_public] == 'public')
    redirect_to namespace_repository_path(@namespace.name, @repository.name)
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
