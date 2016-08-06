class Admin::NamespacesController < ApplicationController
  def index
    @namespaces = Namespace.order(:id).page params[:page]
  end
end
