class RolesController < ApplicationController
  def index
    respond_to do |format|
      format.html { render_ui }
      format.json { render json: team.roles }
    end
  end

  private

  def team
    @team ||= policy_scope(Team).find_by(slug: params[:team_id])
  end
end
