class CalendarController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json do
        # TODO: scope events properly
        events = EventsBetween.new(*range)
        render json: events.counts_by_day
      end
    end
  end

  private

  def range
    start = Time.zone.local(params[:year], params[:month])
    [start, start + 1.month]
  end
end
