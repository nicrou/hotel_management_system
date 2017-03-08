class Component < ApplicationRecord
  attr_accessor :city
  attr_accessor :place
  attr_accessor :place_id
  attr_accessor :zoom
  attr_accessor :api_key

  # These are additional validations for the virtual attributes that are activated during the creation of the map and slider components ONLY.
  # :if => Proc.new { |a| a.is_map == true }, :if => Proc.new { |a| a.is_editable == true }
  # Right after creation is_editable is set to false so that:
  # 1. No edit column is displayed at the bootstrap-table for slider and/or map components.
  # 2. No validations will occur because of blank virtual attributes while creating objects with the :is_map attribute for display usages or has_and_belongs_to_many associations.

  validates :place, presence: { message: 'can\'t be blank unless there is a Place ID' },
                    if: [:is_map?, :is_editable?], unless: Proc.new { |a| a.place_id.present? }
  validates :city, presence: { message: 'can\'t be blank unless there is a Place ID' },
                    if: [:is_map?, :is_editable?], unless: Proc.new { |a| a.place_id.present? }
  validates :zoom, presence: true, numericality: { only_integer: true },
                    if: [:is_map?, :is_editable?]
  validates :api_key, presence: true,
                    if: [:is_map?, :is_editable?]
  validates :collection_directory, presence: true, if: :is_slider?
  validates :title, presence: true
  validates :content, presence: true

  has_and_belongs_to_many :contents

  def escape_primes
    self.content.gsub("'","\\\\'")
  end
end
