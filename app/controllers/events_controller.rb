class EventsController < ApplicationController
  include EventOccurrences

  def show
    respond_to do |format|
      format.html { render_ui }
      format.json do
        if occurrence.present?
          render json: event, occurrence: occurrence
        else
          head :not_found
        end
      end
    end
  end

  def new
    @event = team.events.build
    respond_to do |format|
      format.html { render_ui }
      format.json { render json: @event }
    end
  end

  def check
    @event = params[:id] && team.events.find(params[:id]) || team.events.build
    @event.attributes = event_params
    render json: @event, status: @event.valid? ? :ok : :unprocessable_entity
  end

  private

  def event_id
    params[:event_id] || params[:id]
  end

  def event_params
    params
      .require(:event)
      .permit(:name, :slug, :starts_at, :duration, :time_zone_name)
  end
end
