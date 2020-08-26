class User < ApplicationRecord
  validates :email, uniqueness: true, presence: true
  has_many(
    :submitted_urls,
    class_name: 'ShortenedUrl'
  )

  has_many :visits

  has_many :visited_urls,
    -> { distinct },
    through: :visits,
    source: :shortened_url
  
end