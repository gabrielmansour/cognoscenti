class Contact < ApplicationRecord
  has_many :topics, dependent: :destroy

  validates :name, :url, :shortened_url, presence: true
  validates :url, :shortened_url, format: URI.regexp

  before_validation :shorten_url, on: :create, if: :url?
  after_create :hydrate_topics

  private

  def shorten_url
    return unless url?
    self.shortened_url = ShortURL.shorten(url)
  end

  def hydrate_topics
    WebScraper.new(url, id).call
  end
end
