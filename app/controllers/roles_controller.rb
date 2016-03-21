class RolesController < ApplicationController
  def index
    respond_to do |format|
      format.html { render_ui }
      format.json { render json: team.roles }
    end
  end

  def create
    @role = team.roles.build(role_params)
    saved = role.save
    render json: @role, status: saved ? :ok : :unprocessable_entity
  end

  def update
    role.attributes = role_params
    saved = role.save
    render json: @role, status: saved ? :ok : :unprocessable_entity
  end

  def check
    @role = params[:id] && team.roles.find(params[:id]) || team.roles.build
    @role.attributes = role_params

    @role.validate
    render json: @role, status: @role.valid? ? :ok : :unprocessable_entity
  end

  private

  def role_params
    return {} unless params[:role].present?
    params.require(:role).permit(:name, :plural)
  end

  def role
    @role ||= team.roles.find(params[:id])
  end

  def team
    @team ||= policy_scope(Team).find_by(slug: params[:team_id])
  end
end
