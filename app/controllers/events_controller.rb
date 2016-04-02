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

  private

  def event
    @event ||= team.events.find_by!(slug: params[:id])
  end
end
