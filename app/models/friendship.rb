class Friendship < ApplicationRecord
  belongs_to :contact
  belongs_to :friend, class_name: Contact.name

  validate :validate_cannot_befriend_self

  def self.between(contact1, contact2)
    where(contact: contact1, friend: contact2)
      .or where(contact: contact2, friend: contact1)
  end

  def self.including(contact)
    where(contact: contact).or(where(friend: contact))
  end

  private

  def validate_cannot_befriend_self
    errors.add(:contact_id, 'cannot befriend yourself!') if contact_id == friend_id
  end
end
