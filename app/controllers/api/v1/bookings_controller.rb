class Api::V1::BookingsController < ApplicationController

  def index
    # unless params.has_key? :date_time
    #   render json: {message: "no date_time"}, status: 422
    #   return
    # end
    available_slots = Booking.available_slots( params[:date_time], params[ :sport])
    render json: available_slots
  end

  def create

  end

  def update

  end

  def delete

  end
end
