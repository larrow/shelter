class SearchController < ApplicationController
  def index
    if user_signed_in?
      @repositories = Repository.where(is_public: true)
        .or(Repository.where(id: current_user.repositories.pluck(:id)))
        .where('name like ?', "%#{params[:q]}%")
    else
      @repositories = Repository.where(is_public: true).where('name like ?', "%#{params[:q]}%")
    end
  end
end
