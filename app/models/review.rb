class Review < ApplicationRecord
  belongs_to :user

  scope :filter_by_user, -> (user_id) { where user_id: user_id }
  # scope :filter_from_user, -> (from_user) { where from_user: from_user }
  # scope :filter_skipped, -> (is_skip) { where is_skip: is_skip }
  scope :filter_by_stars, -> (stars) { where.not stars: stars }
  # scope :filter_by_nil, -> (is_nil) { where stars: is_nil }
end
