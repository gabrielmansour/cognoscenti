class Contact < ApplicationRecord
  validates :name, :url, :shortened_url, presence: true
  validates :url, :shortened_url, format: URI.regexp

  before_validation :shorten_url, on: :create, if: :url?

  def topics
    [] # TODO
  end

  private

  def shorten_url
    self.shortened_url = ShortURL.shorten(url)
  end
end
