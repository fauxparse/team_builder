class Users::SessionsController < Devise::SessionsController
  private

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(:user) || signed_in_root_path(:user)
  end
end
