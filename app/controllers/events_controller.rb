class EventsController < ApplicationController
  def show
    @occurrence = if date.present?
      event.occurrence_on!(date)
    else
      event.first_occurrence
    end

    respond_to do |format|
      format.html { render_ui }
      format.json { render json: event, occurrence: @occurrence }
    end
  end

  private

  def event
    @event ||= team.events.find_by!(slug: params[:id])
  end

  def team
    @team ||= policy_scope(Team).find_by!(slug: params[:team_id])
  end

  def date
    Date.new *[params[:year], params[:month], params[:day]].map(&:to_i)
  rescue
    nil
  end
end
