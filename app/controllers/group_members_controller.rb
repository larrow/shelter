class GroupMembersController < ApplicationController
  before_action :process_params
  before_action :authenticate_user!

  def index
    @members = @group.members
  end

  def new
    @member = @group.members.new
  end

  def create
    authorize! :update, @group
    @group.add_user(User.where(username: params[:username]).or(User.where(email: params[:username])).first, :member, current_user)
    redirect_to namespace_group_members_path(@group.name), notice: 'The user has been invited.'
  end

  def destroy
    authorize! :update, @group
    redirect_to namespace_group_members_path(@group.name), alert: 'The last collaborators can\'t be removed' and return if @group.members.length == 1
    @group.members.delete(@group.members.find(params[:id]))
    redirect_to namespace_group_members_path(@group.name), notice: 'The member has been removed.'
  end

  def toggle_access_level
    authorize! :update, @group
    member = @group.members.find_by(id: params[:id]) || (redirect_to namespace_group_members_path(@group.name) and return)
    member.update_attribute(:access_level, params[:access_level])
    redirect_to namespace_group_members_path(@group.name), notice: 'Access level changed successfully.'
  end

  private

  def process_params
    @group = Group.find_by!(name: params[:namespace_id])
  end
end
