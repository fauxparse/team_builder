class AvailabilityController < ApplicationController
  include EventOccurrences

  respond_to :json

  def show
    if occurrence.present?
      render json: AvailabilityHash.new(occurrence)
    else
      head :not_found
    end
  end

  def update
    if UpdateAvailability.new(occurrence, availability_params).call
      render json: AvailabilityHash.new(occurrence)
    else
      head :unprocessable_entity
    end
  end

  private

  def availability_params
    params.require(:availability)
      .permit(*(params[:availability] || {}).keys)
  end
end
