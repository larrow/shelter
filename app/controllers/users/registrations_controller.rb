class Users::RegistrationsController < Devise::RegistrationsController
# before_action :configure_sign_up_params, only: [:create]
# before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    if Setting.self_registration
      super
    else
      redirect_to root_path, alert: 'Self registrations are not open yet'
    end
  end

  # POST /resource
  def create
    if Setting.self_registration
      super
    else
      redirect_to root_path, alert: 'Self registrations are not open yet'
    end
  end

end
