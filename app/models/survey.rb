class Survey < ApplicationRecord

  def observation_count
    attributes.values.select(&:present?).count - 6
  end

  def fake_username
    ["Alexander", "Benjamin", "Christopher", "David", "Ethan", "Gabriel", "Henry", "James", "John", "Michael", "Abigail", "Emily", "Elizabeth", "Hannah", "Isabella", "Jasmine", "Julia", "Lily", "Olivia", "Sophia"].sample
  end
end
