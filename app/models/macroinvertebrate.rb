class Macroinvertebrate < ApplicationRecord
  belongs_to :survey
  
  has_many_attached :animal_images
  validates :animal_images, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg']}

  before_save  :change_image_filenames


  def change_image_filenames
    if self.animal_images.attached?

      self.animal_images.attachments.each do | attachment |
  
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