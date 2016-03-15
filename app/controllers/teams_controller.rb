class TeamsController < ApplicationController
  respond_to :html, :json

  after_action :set_current_team, except: [:index, :destroy]

  def index
    respond_to do |format|
      format.html { redirect_to current_team || new_team_path }
      format.json { render json: team_scope }
    end
  end

  def show
    @team = team_scope.find_by!(slug: params[:id])
    respond_with @team
  end

  def new
    @team = Team.new
    respond_with @team
  end

  def create
    @create = CreateTeam.new(current_user, team_params)
    @create.call
    respond_with @create.team
  end

  def check
    @team = params[:id] && Team.find(:id) || Team.new
    @team.attributes = team_params
    @team.validate
    respond_with @team
  end

  private

  def team_params
    params.require(:team).permit(:name, :slug)
  end

  def set_current_team
    cookies[:team_id] = @team.id if @team.present?
  end

  def team_scope
    policy_scope(Team)
  end
end
