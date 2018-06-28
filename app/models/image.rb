class Image < ApplicationRecord
    validates :identifier, presence: true, uniqueness: true
    validates :url, presence: true
  end
  