class MembersController < ApplicationController
  respond_to :html, :json

  def create
    form = AddMembersForm.new(current_user, team, params).process

    respond_to do |format|
      format.json { render json: form.members }
    end
  end

  private

  def team
    @team ||= policy_scope(Team).where(slug: params[:team_id])
  end
end
