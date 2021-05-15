class UserActiveEvent < ApplicationRecord
  has_many :users
  has_many :events

  scope :filter_by_user, -> (user_id) { where user_id: user_id }
end
