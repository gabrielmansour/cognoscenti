class CreateTopics < ActiveRecord::Migration[6.0]
  def change
    create_table :topics do |t|
      t.text :name, null: false
      t.references :contact, null: false, foreign_key: true
      t.integer :heading_level

      t.timestamps null: false

      t.index :name
    end
  end
end
