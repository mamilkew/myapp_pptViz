class Idea < ApplicationRecord
  validates :description, length: { maximum: 20 }
  validates :name, presence: true
  mount_uploader :picture, PictureUploader

end
