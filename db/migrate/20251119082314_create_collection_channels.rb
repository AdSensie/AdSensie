class CreateCollectionChannels < ActiveRecord::Migration[8.0]
  def change
    create_table :collection_channels do |t|
      t.references :collection, null: false, foreign_key: true
      t.references :channel, null: false, foreign_key: true
      t.text :notes
      t.integer :position

      t.timestamps
    end
  end
end
