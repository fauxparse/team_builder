class OmniauthController < ApplicationController
  skip_before_action :authenticate_user!

  def google_oauth2
    user = UserFromOauth.new(request.env['omniauth.auth']).user
    sign_in_and_redirect(user)
  end
end
