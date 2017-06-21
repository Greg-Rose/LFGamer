class Game < ApplicationRecord
  has_many :games_consoles
  has_many :consoles, through: :games_consoles

  mount_uploader :cover_image, GameCoverImageUploader

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :cover_image, presence: true
  validates :online, inclusion: { in: [ true, false ] }
  validates :split_screen, inclusion: { in: [ true, false ] }
  validates :consoles, presence: true
end
