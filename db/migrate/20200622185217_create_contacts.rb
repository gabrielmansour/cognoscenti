class CreateContacts < ActiveRecord::Migration[6.0]
  def change
    create_table :contacts do |t|
      t.text :name, null: false
      t.text :url, null: false
      t.text :shortened_url, null: false

      t.timestamps null: false
    end
  end
end
