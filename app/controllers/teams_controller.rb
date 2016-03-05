class TeamsController < ApplicationController
  respond_to :html, :json

  after_action :set_current_team, except: [:index, :destroy]

  def index
    respond_to do |format|
      format.html { redirect_to current_team if current_team }
      format.json { render json: team_scope }
    end
  end

  def show
    @team = team_scope.find_by!(slug: params[:id])
    respond_with @team
  end

  private

  def set_current_team
    if @team.present?
      cookies[:member_id] = @team.members
        .find_by(user_id: current_user.id)
        .try(:id)
    end
  end

  def team_scope
    policy_scope(Team)
  end
end
