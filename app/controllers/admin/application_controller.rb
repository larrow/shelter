module Admin
  class ApplicationController < ::ApplicationController
    before_action :authenticate_user!
    before_action :authenticate_admin!

    def authenticate_admin!
      redirect_to root_path unless user_signed_in? && current_user.admin?
    end
  end
end
