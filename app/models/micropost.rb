class Micropost < ActiveRecord::Base
  belongs_to :user
  # This is a procedure that tells rails how to order microposts
  default_scope -> { order(created_at: :desc) }

  mount_uploader :picture, PictureUploader

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate :picture_size

  private

    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "Files must be smaller than 5MB")
      end
    end

end
