class TagTopic < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :taggings, dependent: :destroy

  has_many :shortened_urls,
    through: :taggings,
    source: :shortened_url

  def popular_links
    
  end
end