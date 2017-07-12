class Profile < ApplicationRecord
  belongs_to :user

  validates :zipcode, length: { is: 5 }
end
