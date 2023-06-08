class Survey < ApplicationRecord
  belongs_to :user
  has_many_attached :images
  has_many :macroinvertebrates
  accepts_nested_attributes_for :macroinvertebrates, allow_destroy: true, reject_if: :all_blank

  validates :images, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg']}
 
  after_commit :update_user_contribution_count

  paginates_per 20
  max_paginates_per 150
  
  def observation_count
    attributes.values.select(&:present?).count - 6
  end

  
  def update_user_contribution_count
    user.update_contribution_count
  end


  
end
