class CreateShortenedUrls < ActiveRecord::Migration[6.0]
  def change
    create_table :shortened_urls do |t|
      t.string :long_url
      t.string :short_url, unique: true
      t.integer :user_id
      t.index :user_id

      t.timestamps
    end
  end
end
