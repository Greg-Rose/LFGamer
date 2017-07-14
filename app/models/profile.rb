class Profile < ApplicationRecord
  belongs_to :user

  NULL_ATTRS = %w( psn_id xbox_gamertag about_me zipcode )
  before_save :nil_if_blank

  validates :about_me, length: { maximum: 200 }
  validates :zipcode, format: { with: /\A\d{5}\z/, message: "must be 5 digits" }, allow_nil: true, allow_blank: true

  protected

  def nil_if_blank
    NULL_ATTRS.each { |attr| self[attr] = nil if self[attr].blank? }
  end
end
