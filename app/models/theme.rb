class Theme < ApplicationRecord
  def Theme.selected_theme
    return Theme.where(selected: true).first  # returns value if exists, or initializes it
  end
end
