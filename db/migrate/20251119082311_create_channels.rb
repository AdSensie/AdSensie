class CreateChannels < ActiveRecord::Migration[8.0]
  def change
    create_table :channels do |t|
      t.string :telegram_id
      t.string :username
      t.string :title
      t.text :description
      t.integer :subscriber_count
      t.integer :avg_views
      t.decimal :avg_engagement_rate
      t.decimal :growth_rate
      t.decimal :post_frequency
      t.datetime :last_synced_at

      t.timestamps
    end
    add_index :channels, :telegram_id, unique: true
  end
end
