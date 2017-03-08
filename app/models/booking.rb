class Booking < ApplicationRecord
  validates :room_id, presence: true, numericality: { only_integer: true }
  validates :start_date, presence: true
  validates :nights, presence: true, numericality: { only_integer: true }
  validates :qty, presence: true, numericality: { only_integer: true }
  validates :guests, numericality: { only_integer: true }, allow_nil: true
  validates :price, presence: true, numericality: true
  validates :discount, numericality: true
  belongs_to :invoice, optional: true
  belongs_to :room

  monetize :price_cents

  before_destroy :update_invoice

  def self.find_available_rooms(start_date, nights)

    end_date = start_date + nights
    anavailable_rooms = Array.new
    anavailable_rooms = self.where(self.arel_table[:start_date].lt(end_date)).
                             where(self.arel_table[:end_date].gt(start_date)).distinct.pluck(:room_id)

    rooms = Room.where.not(id: anavailable_rooms)
    return rooms
  end

  def expand_booking
    expanded_booking = Array.new
    qty = self.qty;
    # qty is the extracted quantity requested of a specific room type in a booking object.
    # notice that at this point each booking object refers to a batch of rooms. Booking and Room models have a 'one to one' association.
    # ie. if booking.qty = 3 for room_categories_id == 1, it means that 3 seperate bookings should result from this one.
    result = find_choices
    # result contains an array composed of Room.id values from all the available rooms of the requested type.
    # ie. result => [13, 14, 17, 22, 34] where booking.room_categories_id == 1, while 1 could refer to "Single Room".
    (0..qty-1).each do |i|
      expanded_booking << select_room(result)
      result.delete(expanded_booking[i].room_id)
      # the room that was selected previously is removed from the resulted available room list.
      # The list is then resused in case more rooms of the same type were requested.
    end
    return expanded_booking
      # returns an array of seperate bookings resulted from the qty of the seed booking with their respective Room.id set.
  end

  private

  def find_choices

    available_rooms = Booking.find_available_rooms(self.start_date, self.nights).where(category_id: self.room_id)
    return available_rooms.pluck(:id)
  end

  def select_room(available_rooms)
    if Booking.count.zero?
      room = available_rooms.first
    else

      # Selects the room from those available that it's next booking is closest to the completion of the one in progress.
      x = Booking.where(room_id: available_rooms).where("start_date >= ? ", self.start_date).order(start_date: :asc)
                # where(collective.arel_table[:start_date].gteq(start_date)).order(start_date: :asc).first.room_id
      if x.empty?
        room = available_rooms[0]
      else
        room = x.first.room_id
      end
    end

    tmp_booking = self.dup
    # creates a specific booking object to hold 1-1 information for the specific room that will be selected.
    tmp_booking.room_id = room
    tmp_booking.end_date = tmp_booking.start_date + tmp_booking.nights
    tmp_booking.qty = 1
    return tmp_booking
  end

  def update_invoice
    invoice = Invoice.find(self.invoice_id)
    total = invoice.total
    total -= ((self.price - (self.price * self.discount)/100) * self.nights).round(2)
    invoice.update_attribute(:total, total)
  end
end
