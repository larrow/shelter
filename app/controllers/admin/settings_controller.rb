module Admin
  class SettingsController < Admin::ApplicationController
    def edit
    end

    def update
      Setting.self_registration = params[:self_registration] == '1'
      Setting.allow_push = params[:allow_push] == '1'
      redirect_to edit_admin_setting_path
    end
  end
end
