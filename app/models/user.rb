class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  scope :active_accounts, -> { where(deleted_at: nil) }
  scope :deleted_accounts, -> { where.not(deleted_at: nil) }

  # Virtual attribute for authenticating by either username or email
  attr_accessor :login

  has_one :profile, dependent: :destroy
  has_many :ownerships, dependent: :destroy
  has_many :games_consoles, through: :ownerships
  has_many :games, -> { distinct }, through: :games_consoles
  has_many :consoles, -> { distinct }, through: :games_consoles
  has_many :lfgs, through: :ownerships
  has_many :conversations, ->(user) { unscope(:where).involving(user) }, dependent: :destroy
  has_many :messages

  before_create :build_profile

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :username, presence: true
  validates :username, uniqueness: { case_sensitive: false }
  validates :username, format: { with: /\A[a-zA-Z0-9]+\Z/, message: "must only contain letters and numbers" }
  validates :admin, inclusion: { in: [true, false] }

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    end
  end

  # instead of deleting, indicate the user requested a delete & timestamp it
  def soft_delete_with_password(params)
    current_password = params.delete(:current_password)
    result = if valid_password?(current_password)
      # delete all of the users current LFGs
      lfgs.each { |lfg| lfg.destroy }
      update_attribute(:deleted_at, Time.current)
    else
      self.valid?
      self.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
      false
    end

    result
  end

  # ensure user account is active
  def active_for_authentication?
    super && !deleted_at
  end

  # provide a custom message for a deleted account
  def inactive_message
    !deleted_at ? super : :deleted_account
  end

  def has_game?(game)
    games.include?(game)
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
