module EventOccurrences
  extend ActiveSupport::Concern

  private

  def occurrence
    @occurrence ||= if date.present?
      event.occurrence_on(date)
    else
      event.first_occurrence
    end
  end

  def event
    @event ||= team.events.find_by!(slug: event_id)
  end

  def event_id
    params[:event_id]
  end

  def team
    @team ||= policy_scope(Team).find_by!(slug: params[:team_id])
  end

  def date
    Date.new(*[params[:year], params[:month], params[:day]].map(&:to_i))
  rescue
    nil
  end
end
