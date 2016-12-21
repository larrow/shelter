class NamespacesController < ApplicationController
  before_action :process_params, except: [:create, :new]
  before_action :authenticate_user!, except: :show

  def create
    redirect_back fallback_location: root_path, alert: t('.exists') and return if Namespace.find_by(name: params[:namespace][:name])
    @namespace = current_user.create_namespace(params[:namespace][:name], params[:namespace][:default_publicity])
    if @namespace.errors.empty?
      redirect_to namespace_path(@namespace.name)
    else
      render :new
    end
  end

  def new
    @namespace = current_user.owned_namespaces.new
  end

  def show
    authorize! :read, @namespace
    @repositories = @namespace.repositories.order(updated_at: :desc).page(params[:page])
    @repositories = @repositories.where(is_public: true) unless user_signed_in? && can?(:update, @namespace)
  end

  def destroy
    authorize! :write, @namespace
    status = @namespace.check_destroy

    if status
      redirect_back fallback_location: dashboard_index_path, alert: t(status)
    else
      @namespace.destroy
      redirect_to dashboard_index_path, notice: t('.namespace_deleted')
    end
  end

  def settings
    authorize! :read, @namespace
  end

  private

  def process_params
    @namespace = Namespace.find_by(name: params[:id])
    head 404 if @namespace.nil?
  end
end
