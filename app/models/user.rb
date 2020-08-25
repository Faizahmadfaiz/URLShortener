class User < ApplicationRecord
  validates :email, uniqueness: true, presence: true
  has_many(
    :submitted_urls,
    class_name: 'ShortenedUrl'
  )

  has_many :visits

  has_many(
    :visited_urls, through: :visits, source: :shortened_url,
    class_name: 'ShortenedUrl'
  )

  def num_clicks

  end

  def num_uniques

  end

  def num_recent_uniques

  end
end