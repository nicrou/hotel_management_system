class Customer < ApplicationRecord
  validates :forename, presence: true
  validates :surname, presence: true
  validates :mobile_phone, presence: true, numericality: { only_integer: true }
  validates :email, presence: true
  validates :reason, presence: true

  after_initialize :default_values

  def default_values
    self.reason ||= 'Vacation'
  end
end
