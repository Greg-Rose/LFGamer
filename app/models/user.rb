class User < ApplicationRecord
  # Virtual attribute for authenticating by either username or email
  attr_accessor :login

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :username, presence: true
  validates :username, uniqueness: { case_sensitive: false }
  validates :username, format: { with: /\A[a-zA-Z0-9]+\Z/, message: "must only contain letters and numbers" }
  validates :admin, inclusion: { in: [true, false] }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_hash).first
    end
  end
end
