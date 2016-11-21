class SearchController < ApplicationController
  def index
    if user_signed_in?
      @repositories = Repository.where(is_public: true).or(current_user.repositories).where('name like ?', "%#{params[:q]}%")
    else
      @repositories = Repository.where(is_public: true).where('name like ?', "%#{params[:q]}%")
    end
  end
end
