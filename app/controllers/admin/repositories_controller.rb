class Admin::RepositoriesController < ApplicationController
  def index
    @repositories = Repository.all
  end
end
