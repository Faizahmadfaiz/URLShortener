class ShortenedUrl < ApplicationRecord
  validates :short_url, :long_url, presence: true
  validates :short_url, uniqueness: true

  belongs_to(
    :submitter,
    class_name: 'User',
    foreign_key: :user_id
  )

  def self.random_code
    random_code = SecureRandom.urlsafe_base64(16)
  end

  def self.create_for_user_and_long_url!(user, long_url)
    ShortenedUrl.create!(
      user_id: user.id,
      long_url: long_url,
      short_url: ShortenedUrl.random_code
    )
  end
end