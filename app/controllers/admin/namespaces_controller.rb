class Admin::NamespacesController < ApplicationController
  def index
    @namespaces = Namespace.all
  end
end
