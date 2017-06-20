class Console < ApplicationRecord
  has_many :games_consoles
  has_many :games, through: :games_consoles

  mount_uploader :logo, ConsoleLogoUploader

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :logo, presence: true
end
