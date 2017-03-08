class BookingsController < ApplicationController
  before_action :authenticate_user!, :except => [:search, :result]
  layout :resolve_layout
  include BookingsHelper
  include CurrencyHelper

  def index
    @bookings = Booking.all

    respond_to do |format|
      format.js { render 'shared/index' }
      format.html {}
    end
  end

  def show
    @booking = Booking.find(params[:id])

    respond_to do |format|
      format.js {}
    end
  end

  def new
  end

  def create
  end

  def edit
    @booking = Booking.find(params[:id])

    respond_to do |format|
        format.js {}
    end
  end

  def update
    @booking = Booking.find(params[:id])
    @bookings = Booking.all

    respond_to do |format|
      if Room.exists?(id: params[:booking][:room_id])
        if @booking.update(booking_params)
          format.js {}
        else

          format.js { render action: 'edit' }
        end
      else
        @booking.errors[:room_id] << "Invalid id."
        format.js { render action: 'edit' }
      end
    end
  end

  def destroy
   @booking = Booking.find(params[:id])
   @booking.destroy

   respond_to do |format|
      format.html { redirect_to bookings_url }
      format.json { head :no_content }
      format.js   { render :layout => false }
    end
  end

  def search
    respond_to do |format|
      format.html {}
    end
  end

  def result
    validate_selection
    @available_rooms = Booking.find_available_rooms(@start_date, @nights)
    @categories = Category.find_each
    @count = @available_rooms.group(:category_id).count

    respond_to do |format|
      format.js {}
    end
  end

  def resolve_layout
    if current_user.present?
      "admin"
    else
      "user"
    end
  end

  private
  def booking_params
    params.require(:booking).permit(:room_id, :start_date, :nights, :guests, :comments)
  end

  def validate_selection
    params.permit(:start_date, :end_date)
    if params[:start_date].present?
      @start_date = Date.parse params[:start_date]
    end

    if params[:end_date].present?
      dates = string_to_dates(params[:start_date], params[:end_date])
      dates = validate_dates(dates)
      @start_date = dates[0]
      @nights = (dates[1] - dates[0]).to_i
    end

    if params[:nights].present?
      @nights = params[:nights].to_i
    end
  end
end
