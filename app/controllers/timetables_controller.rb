class TimetablesController < ApplicationController
  before_action :authenticate_user!
  layout 'admin'
  include TimetablesHelper


  def index
    set_parameters
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  def set_parameters
    params.permit(:category, :month)
    @month = get_month(params[:month])

    if params.has_key?(:category) || Category.any?
      @category = params[:category]
      categories = select_category(@category)

      @timetables = Array.new

      if categories.respond_to?(:each)
        categories.each do |category|
          @timetables << initialize_timetable(category)
        end
      else
        @timetables << initialize_timetable(categories)
      end
    else
      @timetables = []
    end
  end

  def initialize_timetable(category)
    timetable = Array.new

    rooms = Room.where(category_id: category.id)
    rooms.each do |room|
      bookings = Booking.where(room_id: room.id).where(Booking.arel_table[:start_date].lt(@month.end_of_month)).where(Booking.arel_table[:end_date].gt(@month.beginning_of_month)).order(start_date: :asc)

      tm_object = TimetableInfo.new(room, bookings)
      timetable << tm_object
    end
    return timetable
  end
end
