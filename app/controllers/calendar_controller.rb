class CalendarController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json do
        events = EventsBetween.new(*range, scope)
        render json: events.counts_by_day
      end
    end
  end

  def show
    events = EventsBetween.new(*range, scope)
    render json: events.occurrences
  end

  private

  def range
    start = if params[:day]
      Time.zone.local(params[:year], params[:month], params[:day])
    elsif params[:month]
      Time.zone.local(params[:year], params[:month])
    elsif params[:year]
      Time.zone.local(params[:year])
    else
      Time.zone.now.beginning_of_month
    end

    period = params[:day] ? 1.day : 1.month
    [start, start + period]
  end

  def scope
    @scope ||= if params[:team_id]
      policy_scope(team.events)
    else
      policy_scope(Event)
    end
  end

  def team
    @team ||= params[:team_id] &&
      policy_scope(Team).find_by!(slug: params[:team_id])
  end
end
