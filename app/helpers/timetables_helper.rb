module TimetablesHelper
  class TimetableInfo
    attr_accessor :room, :bookings

    def initialize(room, bookings)
      @bookings = bookings
      @room = room
    end
  end

  def get_month(d)
    if d.blank?
      d = Date.today
    else
      unless d.is_a?(Date)
        d = Date.parse d
      end
    end
    return d
  end

  def select_category(category)
    if category.blank?
      category = Category.first
    else
      if category != "All"
        category = Category.where(title: category).first
      else
        category = Category.find_each
      end
    end
    return category
  end
end
