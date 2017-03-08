class Content < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :locale, presence: true

  has_and_belongs_to_many :components

  def escape_primes
    self.content.gsub("'","\\\\'")
  end
end
