class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.references :channel, null: false, foreign_key: true
      t.bigint :telegram_message_id
      t.text :text
      t.integer :views
      t.integer :forwards
      t.integer :replies
      t.datetime :posted_at

      t.timestamps
    end
  end
end
