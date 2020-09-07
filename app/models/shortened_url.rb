class ShortenedUrl < ApplicationRecord
  validates :short_url, :long_url, :submitter, presence: true
  validates :short_url, uniqueness: true
  validate :no_spamming, :nonpremium_max

  belongs_to(
    :submitter,
    class_name: 'User',
    foreign_key: :user_id
  )

  has_many :visits, dependent: :destroy

  has_many :visitors,
    -> { distinct },
    through: :visits,
    source: :visitor

  has_many :taggings, dependent: :destroy

  has_many :tag_topics,
    through: :taggings,
    source: :tag_topic

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

  def num_clicks
    visits.count
  end

  def num_uniques
    # visits.select(:user_id).distinct.count
    visitors.count
  end

  def num_recent_uniques
    visits
      .select(:user_id)
      .where('created_at > ?', 40.minutes.ago )
      .distinct
      .count
  end

  def self.prune(n)
    ShortenedUrl
      .joins(:submitter)
      .joins('LEFT JOIN visits ON visits.shortened_url_id = shortened_urls.id')
      .where("(shortened_urls.id IN (
        SELECT shortened_urls.id
        FROM shortened_urls
        JOIN visits
        ON visits.shortened_url_id = shortened_urls.id
        GROUP BY shortened_urls.id
        HAVING MAX(visits.created_at) < \'#{n.minute.ago}\'
      ) OR (
        visits.id IS NULL and shortened_urls.created_at < \'#{n.minutes.ago}\'
      )) AND users.premium = \'f\'")
      .destroy_all
  end

  private

  def no_spamming
    last_minute = ShortenedUrl
      .where('created_at > ?', 1.minute.ago )
      .where(user_id: user_id)
      .count

    errors[:maximum] << 'of five short urls per minute' if last_minute >= 5
  end

  def nonpremium_max
    return if User.find(user_id).premium
    url_counts = ShortenedUrl
      .where(user_id: user_id)
      .count
    if url_counts >= 5
      errors[:premium_max] << 'five short urls per user.Upgrade for more'
    end
  end
end