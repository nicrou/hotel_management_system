module BookingsHelper
  def string_to_dates(start_date, end_date)
    x = Array.new
    x[0] = Date.parse start_date
    x[1] = Date.parse end_date
    return x
  end

  def validate_dates(dates) # dates is an array with 2 Date objects. This function rearranges them so the earlier on is the first element.
    if (dates[0] > dates[1])
      dates[0], dates[1] = dates[1], dates[0]
      return dates
    else
      return dates
    end
  end

  def extract_qty(qty, rooms_id) # Ex. "qty"=>["1", "2", "1", "1", "1", "1", "2"], "room_ids"=>["2", "7"]. It returns "qty"=>["2", "2"]
    temp = Array.new
    rooms_id.each do |i|
      temp << qty[i.to_i-1]
    end
    return temp
  end
end
