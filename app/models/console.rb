class Console < ApplicationRecord
  mount_uploader :logo, ConsoleLogoUploader
  
  validates :name, presence: true
  validates :name, uniqueness: true
  validates :logo, presence: true
end
