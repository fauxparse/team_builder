class ApplicationController < ActionController::Base
  include Pundit

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  after_action :render_blank_page, unless: :performed?

  helper_method :current_member, :current_team
  helper_method :stored_location_for

  private

  def current_member
    @current_member ||= cookies[:team_id] &&
      current_user.members.find_by(team_id: cookies[:team_id]) ||
      current_user.members.first
  end

  def current_team
    @current_team ||= current_member.try(&:team)
  end

  def render_ui
    render "/ui"
  end
end
