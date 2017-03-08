module CurrencyHelper
  def number_to_euro(number)
    number_to_currency(number, :unit => '€', precision: 2, separator: ",", delimiter: ".", format: "%n %u")
  end
end
