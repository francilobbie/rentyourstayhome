class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :favorites, dependent: :destroy
  has_many :flats, through: :favorites
  has_many :owned_flats, class_name: "Flat", foreign_key: "user_id", dependent: :destroy
  has_many :favorited_flats, through: :favorites, source: :flat
  has_many :bookings, dependent: :destroy
  has_many :booked_flats, through: :bookings, source: :flat
  has_many :reviews, dependent: :destroy
  has_many :payements, through: :bookings
  # has_many :flats, dependent: :destroy
  has_many :receiving_payements, through: :owned_flats, source: :payements
  has_one :profile, dependent: :destroy, autosave: true, inverse_of: :user


  # Validations

  ROLES = %w[host]
  validates :role, inclusion: { in: ROLES }, allow_nil: true

  # Delegate
  delegate :first_name, :last_name, :full_name, :phone_number, :description, to: :profile, allow_nil: true

  # Callbacks
  after_create :build_default_profile
  after_save :sync_name_to_profile

  # Role-checking methods
  def host?
    role == "host"
  end

  def hostify!
    update!(role: "host")
  end

  def customer?
    role.blank?
  end

  # Admin methods
  def is_admin?
    admin == true
  end

  def make_admin!
    update!(admin: true)
  end

  def remove_admin!
    update!(admin: false)
  end

  def self.ransackable_attributes(auth_object = nil)
    [
      "admin",
      "created_at",
      "email",
      "first_name",
      "id",
      "last_name",
      "updated_at",
      "role",
      "profile_id",
      "profile_first_name",
      "profile_last_name",
      "password",
      "password_confirmation"
    ]
  end

  private

  def build_default_profile
    build_profile(first_name: self.first_name, last_name: self.last_name).save!
  end

  def sync_name_to_profile
    if saved_change_to_first_name? || saved_change_to_last_name?
      profile.update(first_name: first_name, last_name: last_name)
    end
  end
end
