class AvailabilityController < ApplicationController
  include EventOccurrences

  def show
    if occurrence.present?
      render json: AvailabilityHash.new(occurrence)
    else
      head :not_found
    end
  end

  def update
    UpdateAvailability.new(occurrence, availability_params).call
    render json: AvailabilityHash.new(occurrence)
  end

  private

  def availability_params
    params.require(:availability)
      .permit(*(params[:availability] || {}).keys)
  end
end
