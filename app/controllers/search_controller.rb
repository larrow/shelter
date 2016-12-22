class SearchController < ApplicationController

  def index
    @repositories = Repository.where(is_public: true)
    if user_signed_in?
      @repositories = @repositories.or(Repository.where(id: current_user.repositories.pluck(:id)))
    end

    if current_user&.admin?
      @repositories = @repositories.or(Repository.where(is_public: false))
      @namespaces = Namespace.where('name like ?', "%#{params[:q]}%")
    end

    @repositories = @repositories.where('name like ?', "%#{params[:q]}%")

  end





end
