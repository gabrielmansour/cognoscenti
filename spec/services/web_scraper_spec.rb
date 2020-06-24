require 'rails_helper'

RSpec.describe WebScraper do
  let(:url) { 'http://example.com/' }
  let(:contact_id) { 123 }

  let(:relation) { Topic.where(contact_id: contact_id) }

  before do
    # create Contact for the sake of foreign key integrity:
    create(:contact, id: contact_id)
  end

  describe '#call' do
    subject { described_class.new(url, contact_id).call }

    it 'adds new Topics for the current Contact based on the HTML h1,h2,h3 headings' do
      expect { subject }.to change(relation, :count).from(0).to(23)
    end

    it 'creates new Topics only for the current Contact' do
      expect { subject }.to change(Topic, :count).from(0).to(23)
    end

    it 'creates the correct topics', vcr: true do
      topics = [[1, "Main Page"],
      [2, "Did you know ..."],
      [2, "From today's featured article"],
      [2, "From today's featured list"],
      [2, "In the news"],
      [2, "Navigation menu"],
      [2, "On this day"],
      [2, "Other areas of Wikipedia"],
      [2, "Today's featured picture"],
      [2, "Wikipedia languages"],
      [2, "Wikipedia's sister projects"],
      [3, "Contribute"],
      [3, "In other projects"],
      [3, "Languages"],
      [3, "More"],
      [3, "Namespaces"],
      [3, "Navigation"],
      [3, "Personal tools"],
      [3, "Print/export"],
      [3, "Search"],
      [3, "Tools"],
      [3, "Variants"],
      [3, "Views"]]

      expect(relation.pluck(:heading_level, :name)).to eq []
      subject
      expect(relation.pluck(:heading_level, :name)).to match_array topics
    end
  end
end
