class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  after_action :render_blank_page, unless: :performed?

  helper_method :current_member, :current_team

  private

  def current_member
    @current_member ||= begin
      if id = cookies[:member_id]
        current_user.members.find(id)
      else
        current_user.members.first
      end
    end
  end

  def current_team
    current_member.team
  end
end
