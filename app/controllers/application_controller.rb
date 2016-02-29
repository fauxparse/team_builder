class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  after_action :render_blank_page, unless: :performed?

  private

  def render_blank_page
    render nothing: true if request.format.html?
  end
end
