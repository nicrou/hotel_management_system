class Invoice < ApplicationRecord
  #validates :is_paid, presence: true
  belongs_to :customer, :dependent => :destroy
  has_many :bookings, :dependent => :destroy
  monetize :total_cents

  accepts_nested_attributes_for :customer, :bookings, allow_destroy: true

  after_create :set_invoice_code

  def init_transaction
    expanded_bookings = Array.new
    self.bookings.each do |booking|
      # foreach seperate booking object in the invoice form
      expanded_bookings << booking.expand_booking
      # append to expanded_bookings a list of bookings for each respective room.
      # ie. if booking.qty = 3 for room_categories_id == 1.
      # it means that 3 seperate bookings should result from this one and get appended to the expanded_bookings for rooms of room_category_id == 1.
    end

    # maintain a copy of the bookings variable as it is in case the transaction fails and the new form need to be rerendered.
    safe_copy = Marshal.load(Marshal.dump(self.bookings))

    # overwrite the original bookings that contain quantity in batches with detailed, expanded ones refering to a specific room.
    self.bookings.clear
    self.bookings << expanded_bookings
    self.total = calculate_total(self.bookings)
    Invoice.transaction do
      if self.customer.save! && self.save!
        self.bookings.each do |b|
          b.save!
        end
        return true
      end
    end
    rescue ActiveRecord::RecordInvalid => exception
    self.bookings.clear
    self.bookings << safe_copy
  end

  private
  def calculate_total(bookings)
    total = 0
    bookings.each do |b|
      total += ((b.price - (b.price * b.discount)/100) * b.nights).round(2)
    end
    return total
  end

  def set_invoice_code
    code = Time.now.year.to_s + Time.now.month.to_s + Time.now.day.to_s + '%04d' % id.to_s
    self.update_attribute(:code, code)
  end
end
