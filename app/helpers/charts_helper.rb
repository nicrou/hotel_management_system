module ChartsHelper
  class ChartControl
    attr_accessor :data_action, :type, :date, :mode, :category

    def initialize(data_action = 1, type = "line", date = Date.today, mode = "annual", category = "Total")
      @data_action = data_action.to_i
      @type = type
      @date = date_validation(date)
      @mode = mode
      @category = category
    end

    def date_validation(date)
      unless date.is_a?(Date)
        date = Date.parse date
      end
      return date
    end
  end

  class DatasetInfo
    attr_accessor :title, :data, :color_index

    def initialize(title, data, index = 0)
        @title = title
        @data = data
        @color_index = index
    end
  end

  def bookings_count_per_year_data(year = Date.today.year, category = nil)
    data = Array.new
    if category == 'Total'
      data << DatasetInfo.new(category, bookings_count_per_year(year, nil))
    elsif category != 'All'
      category = Category.where(title: category).first
      data << DatasetInfo.new(category.title, bookings_count_per_year(year, category.id), category.id)
    else
      categories = Category.find_each
      categories.each do |category|
        data << DatasetInfo.new(category.title, bookings_count_per_year(year, category.id), category.id)
      end
    end
    return data
  end

  def bookings_count_per_month_data(month = Date.today)
    data = Array.new
    title = 'Booking\'s Count'
    return data << DatasetInfo.new(title, bookings_count_per_month(month), Category.find_each.pluck(:id))
  end

  def bookings_income_per_year_data(year = Date.today.year, category = nil)
    data = Array.new
    if category == 'Total'
      data << DatasetInfo.new(category, bookings_income_per_year(year, nil))
    elsif category != 'All'
      category = Category.where(title: category).first
      data << DatasetInfo.new(category.title, bookings_income_per_year(year, category.id), category.id)
    else
      categories = Category.find_each
      categories.each do |category|
        data << DatasetInfo.new(category.title, bookings_income_per_year(year, category.id), category.id)
      end
    end
    return data
  end

  def bookings_income_per_month_data(month = Date.today)
    data = Array.new
    title = 'Income Amounts'
    return data << DatasetInfo.new(title, bookings_income_per_month(month), Category.find_each.pluck(:id))
  end

  def invoices_count_per_year_data(year = Date.today.year)
    data = Array.new
    (0..1).each do |i|
      if i == 1
        label = "Paid"
        color = 7
      else
        label = "Unpaid"
        color = 1
      end
      data << DatasetInfo.new(label, invoices_count_per_year(year, i), color)
    end
    return data
  end

  def invoices_count_per_month_data(month = Date.today, status = "0")
    data = Array.new

    data << DatasetInfo.new("Payments", invoices_count_per_month(month), [1, 7])
    # 1 will translate to red in the default pallet function, while 7 to green.
    return data
  end

  def invoices_income_per_year_data(year = Date.today.year)
    data = Array.new
    (0..1).each do |i|
      if i == 1
        label = "Paid"
        color = 7
      else
        label = "Unpaid"
        color = 1
      end
      data << DatasetInfo.new(label, invoices_income_per_year(year, i), color)
    end
    return data
  end

  def invoices_income_per_month_data(month = Date.today, status = "0")
    data = Array.new

    data << DatasetInfo.new("Payments", invoices_income_per_month(month), [1, 7])
    # 1 will translate to red in the default pallet function, while 7 to green.
    return data
  end

  def options(x)
    case x
    when 1
      return {
        width: 400, height: 150,
        responsiveAnimationDuration: 2000,
        tooltips: {
          backgroundColor: "rgba(0,0,0,0.8)",
          bodySpacing: 6,
        },
        scales: {
          yAxes: [{ ticks: { beginAtZero: true } }]
        }
      }
    else
      return {
        width: 400, height: 150,
        responsiveAnimationDuration: 2000,
        tooltips: {
          backgroundColor: "rgba(0,0,0,0.8)",
          bodySpacing: 6,
        },
        scales: {
          display: false
        },
        elements: {
          arc: {
            borderColor: "#fff"
          }
        }
      }
    end
  end

  def data(labels, data_object, type)
    case type
    when "line"
      datasets = line(labels, data_object)
    when "bar"
      datasets = bar(labels, data_object)
    else
      datasets = pie(labels, data_object)
    end

    data = {
      labels: labels,
      datasets: datasets
    }
    return data
  end

  private

  def bookings_count_per_year(year, category)
    months = get_months(year)
    rooms = get_rooms_of_category(category)

    dataset = Array.new
    months.each do |month|
      count = Booking.where("start_date >= ?", month.beginning_of_month).
                                     where("start_date <= ?", month.end_of_month).where(room_id: rooms).count
      dataset << count
    end
    return dataset
  end

  def bookings_count_per_month(month)
    dataset = Array.new
    categories = Category.find_each
    categories.each do |category|
      rooms = get_rooms_of_category(category.id)
      count = Booking.where("start_date >= ?", month.beginning_of_month).
                      where("start_date <= ?", month.end_of_month).where(room_id: rooms).count
      dataset << count
    end
    return dataset
  end

  def bookings_income_per_year(year, category)
    months = get_months(year)
    rooms = get_rooms_of_category(category)

    dataset = Array.new
    months.each do |month|
      monthly_sum = 0
      bookings = Booking.where("end_date >= ?", month.beginning_of_month).
                         where("end_date <= ?", month.end_of_month).where(room_id: rooms)
      bookings.each do |booking|
        if booking.discount.present? && booking.discount != 0
          tmp = (booking.price - ( booking.price * booking.discount )/100) * booking.nights
        else
          tmp = booking.price * booking.nights
        end
        monthly_sum += tmp
      end
      if defined? monthly_sum.to_f
        dataset << monthly_sum.to_f
      else
        dataset << 0
      end
    end
    return dataset
  end

  def bookings_income_per_month(month)
    dataset = Array.new
    categories = Category.find_each
    categories.each do |category|
      category_sum = 0
      rooms = get_rooms_of_category(category.id)
      bookings = Booking.where("end_date >= ?", month.beginning_of_month).
                         where("end_date <= ?", month.end_of_month).where(room_id: rooms)
      bookings.each do |booking|
        if booking.discount.present? && booking.discount != 0
          tmp = (booking.price - ( booking.price * booking.discount )/100) * booking.nights
        else
          tmp = booking.price * booking.nights
        end
        category_sum += tmp
      end
      if defined? category_sum.to_f
        dataset << category_sum.to_f
      else
        dataset << 0
      end
    end
    return dataset
  end

  def invoices_count_per_year(year, status)
    months = get_months(year)

    dataset = Array.new
    months.each do |month|
      count = Invoice.where("updated_at >= ?", month.beginning_of_month).
                        where("updated_at <= ?", month.end_of_month).where(is_paid: status).count
      dataset << count
    end

    return dataset
  end

  def invoices_count_per_month(month)
    dataset = Array.new
    invoices = Invoice.where("updated_at >= ?", month.beginning_of_month).
                       where("updated_at <= ?", month.end_of_month)
    paid = 0
    unpaid = 0

    invoices.each do |invoice|
      if invoice.is_paid == true
        paid += 1
      else
        unpaid += 1
      end
    end
    dataset << unpaid
    dataset << paid

    return dataset
  end

  def invoices_income_per_year(year, status)
    months = get_months(year)

    dataset = Array.new
    total = 0
    months.each do |month|
      invoices = Invoice.where("updated_at >= ?", month.beginning_of_month).
                        where("updated_at <= ?", month.end_of_month).where(is_paid: status)
      invoices.each do |i|
        total = total + i.total
      end
    end
    if defined? total.to_f
      dataset << total.to_f
    else
      dataset << 0
    end
    return dataset
  end

  def invoices_income_per_month(month)
    dataset = Array.new
    invoices = Invoice.where("updated_at >= ?", month.beginning_of_month).
                       where("updated_at <= ?", month.end_of_month)
    paid_amount = 0
    unpaid_amount = 0
    invoices.each do |i|
      if i.is_paid == true
        paid_amount += i.total
      else
        unpaid_amount += i.total
      end
    end
    if defined? unpaid_amount.to_f
      dataset << unpaid_amount.to_f
    else
      dataset << 0
    end
    if defined? paid_amount.to_f
      dataset << paid_amount.to_f
    else
      dataset << 0
    end
    return dataset
  end

  def get_rooms_of_category(category_id)
    if category_id.present?
      # If a category is provided, return its rooms.
      rooms = Room.where(category_id: category_id).pluck(:id)
    else
      # If no category is provided, return all the rooms.
      rooms = Room.find_each.pluck(:id)
    end
    # Returns an array of the room ids.
    return rooms
  end

  def get_months(year)
    january = Date.new(year, 1, 1)
    months = Array.new
    (0..11).each do |m|
      months << january + m.month
    end
    # Returns an array of 12 Date objects, one for each month for the year of the provided date.
    return months
  end

  def set_months
    return ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
  end

  def set_categories
    return Category.find_each.pluck(:title)
  end

  def set_pallet(opacity = 1, seed = 0)
    opacity = opacity.to_s
    case seed
    when 1 # Color collection designed for months.
      return [
        "rgba(233, 30, 99, " + opacity + ")",
        "rgba(156, 39, 176, " + opacity + ")",
        "rgba(63, 81, 181, " + opacity + ")",
        "rgba(3, 169, 244, " + opacity + ")",
        "rgba(76, 175, 80, " + opacity + ")",
        "rgba(255, 235, 59, " + opacity + ")",
        "rgba(255, 152, 0, " + opacity + ")",
        "rgba(244, 67, 54, " + opacity + ")",
        "rgba(244, 164, 96, " + opacity + ")",
        "rgba(121, 85, 72, " + opacity + ")",
        "rgba(224, 224, 224, " + opacity + ")",
        "rgba(238, 130, 238, " + opacity + ")"
    ];
  else # Default color collection.
      return [
        "rgba(3, 169, 244, " + opacity + ")",
        "rgba(244, 67, 54, " + opacity + ")",
        "rgba(233, 30, 99, " + opacity + ")",
        "rgba(156, 39, 176, " + opacity + ")",
        "rgba(63, 81, 181, " + opacity + ")",
        "rgba(0, 188, 212, " + opacity + ")",
        "rgba(0, 150, 136, " + opacity + ")",
        "rgba(76, 175, 80, " + opacity + ")",
        "rgba(205, 220, 57, " + opacity + ")",
        "rgba(255, 235, 59, " + opacity + ")",
        "rgba(255, 152, 0, " + opacity + ")",
        "rgba(121, 85, 72, " + opacity + ")",
        "rgba(158, 158, 158, " + opacity + ")"
        ];
    end
  end

  def change_opacity_of(rgba, opacity)
    result = Array.new
    if rgba.is_a?(Array)
      rgba.each do |i|
        result << set_opacity(i, opacity)
      end
    return result
    else
      return set_opacity(rgba, opacity)
    end
  end

  def set_opacity(rgba, opacity)
    x = rgba.dup
    x.slice!("rgba(")
    x.slice!(")")
    x = x.split(",")
    new_rgba = 'rgba('
    (0..2).each do |n|
      new_rgba = new_rgba + x[n] + ', '
    end
    new_rgba = new_rgba + " " + opacity.to_s + ")"
    return new_rgba
  end

  def line(labels, data_object)
    pallet = set_pallet(0.5)

    datasets = Array.new
    background_colors = Array.new
    border_colors = Array.new

    data_object.each do |obj|
      if obj.color_index.is_a?(Array)
        obj.color_index.each do |i|
          i = i % 13
          background_colors << pallet[i]
        end
      else
        i = obj.color_index % 13
        background_colors = pallet[i]
      end

      border_colors = change_opacity_of(background_colors, 1)

      dataset = {
        label: obj.title,
        fill: false,
        lineTension: 0.5,
        backgroundColor: background_colors,
        borderColor: border_colors,
        borderWidth: 2,
        pointBorderColor: border_colors,
        pointBackgroundColor: background_colors,
        pointBorderWidth: 6,
        pointHoverBackgroundColor: background_colors,
        pointHoverBorderColor: border_colors,
        pointHoverBorderWidth: 12,
        data: obj.data
      }
      datasets << dataset
    end
    return datasets
  end

  def bar(labels, data_object)
    pallet = set_pallet(0.5)

    datasets = Array.new
    background_colors = Array.new
    border_colors = Array.new

    data_object.each do |obj|
      if obj.color_index.is_a?(Array)
        obj.color_index.each do |i|
          i = i % 13
          background_colors << pallet[i]
        end
      else
        i = obj.color_index % 13
        background_colors = pallet[i]
      end

      border_colors = change_opacity_of(background_colors, 1)

      dataset = {
        label: obj.title,
        backgroundColor: background_colors,
        borderColor: border_colors,
        borderWidth: 2,
        data: obj.data
      }
      datasets << dataset
    end
    return datasets
  end

  def pie(labels, data_object)
    datasets = Array.new
    background_colors = Array.new
    border_colors = Array.new

    data_object.each do |obj|
      if obj.color_index.is_a?(Array)
        pallet = set_pallet(0.8, 2)
        obj.color_index.each do |i|
          i = i % 13
          background_colors << pallet[i]
        end
      else
        pallet = set_pallet(0.8, 1)
        (0..labels.length-1).each do |i|
          background_colors << pallet[i]
        end
      end

      # border_colors = change_opacity_of(background_colors, 1)

      dataset = {
        label: obj.title,
        backgroundColor: background_colors,
        # borderColor: border_colors,
        borderWidth: 2,
        data: obj.data
      }
      datasets << dataset
    end
    return datasets
  end
end
