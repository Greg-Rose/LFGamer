class Profile < ApplicationRecord
  belongs_to :user

  validates :zipcode, format: { with: /\A\d{5}\z/, message: "must be 5 digits" }, allow_nil: true
end
