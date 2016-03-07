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
    start = if params[:month]
      Time.zone.local(params[:year], params[:month])
    elsif params[:year]
      Time.zone.local(params[:year])
    else
      Time.zone.now.beginning_of_month
    end
    [start, start + 1.month]
  end
end
