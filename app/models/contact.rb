class Contact < ApplicationRecord
  has_many :topics, dependent: :destroy
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships

  validates :name, :url, presence: true
  validates :url, format: URI.regexp
  validates :shortened_url, format: { with: URI.regexp, allow_nil: true }

  before_create :shorten_url
  after_destroy :delete_friendships

  def self.not_friends_with(contact)
     query = where.not(id: contact.id).arel.except(
       joins(:friendships).where(friendships: { friend_id: contact.id }).arel)
     from query.create_table_alias(query, table_name)
  end

  def contact_path
    Array(contact_ids_path).zip(Array(contact_names_path))
  end

  private

  def shorten_url
    return unless url?
    self.shortened_url = ShortURL.shorten(url)
  end

  def delete_friendships
    Friendship.including(id).delete_all
  end
end
