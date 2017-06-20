class Game < ApplicationRecord
  mount_uploader :cover_image, GameCoverImageUploader
  
  validates :name, presence: true
  validates :name, uniqueness: true
  validates :cover_image, presence: true
  validates :online, presence: true
  validates :online, inclusion: { in: [ true, false ] }
  validates :split_screen, presence: true
  validates :split_screen, inclusion: { in: [ true, false ] }
end
