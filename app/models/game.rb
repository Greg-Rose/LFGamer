class Game < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true
  validates :cover_photo, presence: true
  validates :online, presence: true
  validates :online, inclusion: { in: [ true, false ] }
  validates :split_screen, presence: true
  validates :split_screen, inclusion: { in: [ true, false ] }
end
