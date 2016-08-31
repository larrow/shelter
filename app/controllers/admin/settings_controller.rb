module Admin
  class SettingsController < Admin::ApplicationController
    def index
    end

    def update
      Setting.self_registration = params[:self_registration] == '1'
      Setting.allow_push = params[:allow_push] == '1'
      redirect_to admin_settings_path
    end
  end
end
