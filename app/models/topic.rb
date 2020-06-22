class Topic < ApplicationRecord
  belongs_to :contact

  validates :name, :contact, :heading_level, presence: true
  validates :heading_level, inclusion: [1, 2, 3]
end
