class Profile < ApplicationRecord
  belongs_to :user


  geocoded_by :address

  has_one_attached :avatar
  # validates :first_name, :last_name, presence: true


  after_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }

  def complete_address
    [street, city, state, country].compact.join(', ')
  end

  def full_name
    "#{first_name} #{last_name}".squish
  end

  # app/models/profile.rb
  after_save :sync_name_to_user

  private

# app/models/profile.rb
  def sync_name_to_user
    if saved_change_to_first_name? || saved_change_to_last_name?
      user.update_columns(first_name: first_name, last_name: last_name)
    end
  end


end
