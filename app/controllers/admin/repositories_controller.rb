class Admin::RepositoriesController < ApplicationController
  def index
    @repositories = Repository.order(:id).page params[:page]
  end
end
