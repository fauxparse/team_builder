module DeviseControllerMacros
  def login
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      logged_in_user.confirm unless logged_in_user.confirmed?
      sign_in(logged_in_user)
    end
  end
end
