class UserActiveEvent < ApplicationRecord
  scope :filter_by_user, -> (user_id) { where user_id: user_id }
end
