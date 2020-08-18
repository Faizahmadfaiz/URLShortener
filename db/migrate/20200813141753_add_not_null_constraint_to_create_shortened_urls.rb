class AddNotNullConstraintToCreateShortenedUrls < ActiveRecord::Migration[6.0]
  def change
    change_column_null :shortened_urls, :long_url, false
    change_column_null :shortened_urls, :short_url, false
    change_column_null :shortened_urls, :user_id, false
    change_column_null :users, :email, false
  end
end
