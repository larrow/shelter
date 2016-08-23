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
    redirect_to namespace_group_members_path(@group.name), notice: t('.user_invited')
  end

  def destroy
    authorize! :update, @group
    binding.pry
    redirect_to namespace_group_members_path(@group.name), alert: t('.cant_remove_last_owner') and return if @group.owners.length == 1 && @group.members.find(params[:id]).access_level == 'owner'
    @group.members.delete(@group.members.find(params[:id]))
    redirect_to namespace_group_members_path(@group.name), notice: t('.member_removed')
  end

  def toggle_access_level
    authorize! :update, @group
    member = @group.members.find_by(id: params[:id]) || (redirect_to namespace_group_members_path(@group.name) and return)
    member.update_attribute(:access_level, params[:access_level])
    redirect_to namespace_group_members_path(@group.name), notice: t('.changed')
  end

  private

  def process_params
    @group = Group.find_by!(name: params[:namespace_id])
  end
end
