class Survey < ApplicationRecord
  belongs_to :user

  after_commit :update_user_contribution_count
  
  def observation_count
    attributes.values.select(&:present?).count - 6
  end

  
  def update_user_contribution_count
    user.update_contribution_count
  end

end
