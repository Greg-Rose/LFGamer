class Game < ApplicationRecord
  has_many :games_consoles
  has_many :consoles, -> { order(:name) }, through: :games_consoles

  mount_uploader :cover_image, GameCoverImageUploader

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :cover_image, presence: true
  validates :online, inclusion: { in: [ true, false ] }
  validates :split_screen, inclusion: { in: [ true, false ] }
  validates :consoles, presence: true

  def self.search(search)
    where("lower(games . name) LIKE ?", "%#{search.downcase}%")
  end

  def self.browse(search = nil, filter = nil)
    if search && filter
      search(search).joins(:consoles).where(consoles: { id: filter }).preload(:consoles)
    elsif search
      search(search).includes(:consoles)
    elsif filter
      joins(:consoles).where(consoles: { id: filter }).preload(:consoles)
    else
      includes(:consoles)
    end
  end
end
