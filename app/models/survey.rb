class Survey < ApplicationRecord
  belongs_to :user
  has_many_attached :images
  has_many :macroinvertebrates, dependent: :destroy
  accepts_nested_attributes_for :macroinvertebrates, allow_destroy: true, reject_if: :all_blank

  validates :images, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg']}

  validates :width, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :depth, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :ph, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 14 }, allow_nil: true
 
  after_save_commit :update_user_contribution_count
  before_save  :change_image_filenames

  paginates_per 20
  max_paginates_per 150
  
  def observation_count
    attributes.values.select(&:present?).count - 6
  end

  
  def update_user_contribution_count
    user.update_contribution_count
  end



  def change_image_filenames
    if self.images.attached?

      self.images.attachments.each do | attachment |
  
        if attachment.new_record?
          base =  attachment.blob.filename.base
          ext = attachment.blob.filename.extension_with_delimiter

          new_base = base + '_'+('a'..'z').to_a.shuffle[0,8].join
          new_filename = new_base + ext
          # attachment.blob.filename = new_filename
          attachment.blob.update(filename: new_filename)
        end
      
      end

    end
  end

  
end
