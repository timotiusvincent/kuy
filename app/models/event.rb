class Event < ApplicationRecord
  enum status: [ :waiting, :in_progress, :completed ]

  has_many :users
  #belongs_to :user
  # update belongs to
  # User.events.new instead of event.new

  # scope :filter_by_status, -> (status) { where status: status }
  scope :filter_by_city, -> (city) { where city: city }
  scope :filter_by_place, -> (place_id) { where place_id: place_id }
  scope :filter_by_time, ->() { where('start_time > ?', DateTime.now) }
end
