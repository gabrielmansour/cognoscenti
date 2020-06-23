class Contact < ApplicationRecord
  has_many :topics, dependent: :destroy
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships

  validates :name, :url, :shortened_url, presence: true
  validates :url, :shortened_url, format: URI.regexp

  before_validation :shorten_url, on: :create, if: :url?
  after_create :hydrate_topics
  after_destroy :delete_friendships

  def self.not_friends_with(contact)
     query = where.not(id: contact.id).arel.except(
       joins(:friendships).where(friendships: { friend_id: contact.id }).arel)
     from query.create_table_alias(query, table_name)
  end

  private

  def shorten_url
    return unless url?
    self.shortened_url = ShortURL.shorten(url)
  end

  def hydrate_topics
    WebScraper.new(url, id).call
  end

  def delete_friendships
    Friendship.including(id).delete_all
  end
end
