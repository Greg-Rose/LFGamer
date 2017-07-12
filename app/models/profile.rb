class Profile < ApplicationRecord
  belongs_to :user

  validates :zipcode, format: { with: /\A\d{5}\z/ }, allow_nil: true
end
