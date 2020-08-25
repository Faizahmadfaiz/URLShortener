class Visit < ApplicationRecord
  belongs_to :shortened_url
  belongs_to :user

  def self.record_visit!(user, shortened_url)
    Visit.create!(user_id: user.id, shortened_url_id: shortened_url.id)
  end
end