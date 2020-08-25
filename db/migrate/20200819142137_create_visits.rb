class CreateVisits < ActiveRecord::Migration[6.0]
  def change
    create_table :visits do |t|
      t.integer :user_id, null: false
      t.integer :shortened_url_id, null: false
      t.index :user_id
      t.index :shortened_url_id
      t.timestamps
    end
  end
end
