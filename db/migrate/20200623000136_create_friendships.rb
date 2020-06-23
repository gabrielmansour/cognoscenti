class CreateFriendships < ActiveRecord::Migration[6.0]
  def change
    create_table :friendships do |t|
      t.references :contact, null: false, foreign_key: true
      t.references :friend, null: false, foreign_key: { to_table: :contacts }

      t.timestamps

      t.index [:contact_id, :friend_id], unique: true
    end
  end
end
