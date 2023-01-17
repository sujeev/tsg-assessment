class Api::V1::BookingsController < ApplicationController
   before_action :set_booking, only: [:show, :update, :destroy]

  def index
    if params.has_key? :booked
      booked_slots = Booking.booked_slots( params[:date_time], params[ :sport])
      render json: booked_slots
    else
      available_slots = Booking.available_slots( params[:date_time], params[ :sport])
      render json: available_slots
    end
  end

  def create
    @booking = Booking.new(booking_params)
    if @booking.save
      render json: @booking, status: :created
    else
      render json: @booking.errors, status: :unprocessable_entity
    end
  end

  def update
    if @booking.update(booking_params)
      render json: @booking
    else
      render json: @booking.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @booking.destroy
  end

  private

  def booking_params
    params.require(:booking).permit(:date_time, :court_id, :user_id)
  end

  def set_booking
    @booking = Booking.find(params[:id])
  end

end
