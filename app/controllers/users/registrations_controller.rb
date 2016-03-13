class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  protected

  def after_sign_up_path_for(resource_or_scope)
    stored_location_for(:user) || signed_in_root_path(:user)
  end

  def configure_sign_up_params
    devise_parameter_sanitizer
      .permit(:sign_up, keys: [:name])
  end

  def configure_account_update_params
    devise_parameter_sanitizer
      .permit(:sign_up, keys: [:name])
  end
end
