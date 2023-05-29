class Survey < ApplicationRecord
  belongs_to :user

  def observation_count
    attributes.values.select(&:present?).count - 6
  end

end
