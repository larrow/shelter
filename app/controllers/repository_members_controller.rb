class RepositoryMembersController < ApplicationController
  before_action :process_params
  before_action :authenticate_user!

  def index
    @members = @repository.members
  end

  def new
    @member = @repository.members.new
  end

  def create
    authorize! :update, @repository
    @repository.add_user(User.where(username: params[:username]).or(User.where(email: params[:username])).first, :member, current_user)
    redirect_to namespace_repository_members_path(@namespace.name, @repository.name), notice: 'The user has been invited.'
  end

  def destroy
    authorize! :update, @repository
    redirect_to namespace_repository_members_path(@namespace.name, @repository.name), alert: 'The owner can\'t be removed' and return if @repository.members.find(params[:id]).access_level == 'owner'
    @repository.members.delete(@repository.members.find(params[:id]))
    redirect_to namespace_repository_members_path(@namespace.name, @repository.name), notice: 'The member has been removed.'
  end

  private

  def process_params
    @namespace = Namespace.find_by(name: params[:namespace_id])
    @repository = @namespace&.repositories&.find_by(name: params[:repository_id])
  end
end
