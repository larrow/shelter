class SearchController < ApplicationController

  def index
    @repositories = Repository.where(is_public: true).where('name like ?', "%#{params[:q]}%")
    
    if user_signed_in?
      @repositories = @repositories.or(Repository.where(id: current_user.repositories.pluck(:id)))
    end
    if current_user&.admin?
      @namespaces = Namespace.where('name like ?', "%#{params[:q]}%")
    end


  end





end
