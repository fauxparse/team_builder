module DeviseControllerMacros
  def login
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in(logged_in_user)
    end
  end
end
