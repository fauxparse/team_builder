class MembersController < ApplicationController
  respond_to :html, :json

  def index
    respond_to do |format|
      format.html { render_ui }
      format.json { render json: team.members.sort_by(&:display_name) }
    end
  end

  def new
    respond_to do |format|
      format.html { render_ui }
    end
  end

  def create
    form = AddMembersForm.new(current_user, team, params).process

    respond_to do |format|
      format.json { render json: form.members }
    end
  end

  private

  def team
    @team ||= policy_scope(Team).find_by(slug: params[:team_id])
  end
end
