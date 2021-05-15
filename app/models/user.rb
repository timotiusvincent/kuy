class User < ApplicationRecord
  enum gender: [ :female, :male, :unspecified ]

  has_many :events
  has_many :reviews
  has_one_attached :avatar
end
