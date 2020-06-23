class FriendshipCommand
  def self.create(person1, person2)

    now = Time.current

    Friendship.transaction do
      Friendship.create!(contact_id: person1.to_param, friend_id: person2.to_param)
      Friendship.create!(contact_id: person2.to_param, friend_id: person1.to_param)
    end
  end

  def self.unfriend(user1, user2)
    Friendship.between(user1, user2).delete_all
  end
end
