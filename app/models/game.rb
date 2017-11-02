class Game < ApplicationRecord
  has_many :games_consoles
  has_many :consoles, -> { order(:name) }, through: :games_consoles
  has_many :ownerships, through: :games_consoles
  has_many :users, -> { distinct }, through: :ownerships
  has_many :lfgs, through: :ownerships

  mount_uploader :cover_image, GameCoverImageUploader

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :cover_image, presence: true
  validates :online, inclusion: { in: [ true, false ] }
  validates :split_screen, inclusion: { in: [ true, false ] }
  validates :games_consoles, presence: true

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
