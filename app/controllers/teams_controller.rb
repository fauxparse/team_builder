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
    CreateTeam.new(current_user, team_params)
      .on(:success) { |team| render json: team }
      .on(:failure) { |team| render json: team, status: :unprocessable_entity }
      .call
  end

  def check
    @team = params[:id] && Team.find(:id) || Team.new
    @team.attributes = team_params
    @team.validate
    render json: @team, status: @team.valid? ? :ok : :unprocessable_entity
  end

  private

  def team_params
    return {} unless params[:team].present?
    params.require(:team).permit(:name, :slug)
  end

  def set_current_team
    cookies[:team_id] = @team.id if @team.present?
  end

  def team_scope
    policy_scope(Team)
  end
end
