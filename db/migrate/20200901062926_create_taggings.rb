class CreateTaggings < ActiveRecord::Migration[6.0]
  def change
    create_table :taggings do |t|
      t.integer :tag_topic_id, null: false
      t.integer :shortened_url_id, null: false
      t.index %i(tag_topic_id shortened_url_id), unique: true
      t.index :shortened_url_id
      t.timestamps
    end
  end
end
