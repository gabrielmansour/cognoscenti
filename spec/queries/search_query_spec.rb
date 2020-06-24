require 'rails_helper'

RSpec.describe SearchQuery do
  subject(:search_query) { described_class.new(contact) }
  let(:query_text) { 'Hi' }
  let(:contact) { create(:contact, name: 'Alice', topics: %w[Hi Ho High Hoe]) }
  let(:bob) { create(:contact, name: 'Bob', topics: %w[Birthdays Baking Boxes]) }
  let(:cady) { create(:contact, name: 'Cady', topics: %w[Cameras Caps Coral Chickadees]) }
  let(:dylan) { create(:contact, name: 'Dylan', topics: %w[Dance Dragons Daisies Hi]) }
  let(:ed) { create(:contact, name: 'Ed', topics: %w[Epics Education Ethics]) }
  let(:fran) { create(:contact, name: 'Fran', topics: %w[Food Flint Fun]) }

  describe '#call' do
    subject { search_query.call(query_text) }

    context 'when contact has no friends' do
      it { is_expected.to eq [] }
    end

    context 'when has friends but no 2nd-degree friends' do
      before do
        FriendshipCommand.create(contact, bob)
      end
      it { is_expected.to eq [] }
    end

    context 'when has 2nd-degree friends with the matching topic' do
      before do
        FriendshipCommand.create(contact, bob)
        FriendshipCommand.create(bob, cady)
        FriendshipCommand.create(cady, dylan)
        FriendshipCommand.create(cady, ed)
        FriendshipCommand.create(dylan, ed)
        FriendshipCommand.create(bob, fran)
      end

      it 'returns all contacts who have a matching topic and are 2+ degrees away' do
        is_expected.to eq [cady, dylan, ed]
      end

      context 'with a sort order defined' do
        subject { search_query.call(query_text, sort: sort) }
        let(:query_text) { 'Dragon' }
        let(:sort) { 'expertise' }

        before do
          create(:topic, name: 'dragon', contact: cady, heading_level: 3)
          create(:topic, name: 'dragonite', contact: ed, heading_level: 2)
        end

        it 'returns the results ordered by expertise score' do
          is_expected.to eq [dylan, ed, cady]
        end

        context 'unrecognized sort order' do
          let(:sort) { 'reverance' }
          it 'returns the results sorted by the default order (by degrees of separation)' do
            is_expected.to eq [cady, dylan, ed]
          end
        end
      end
    end
  end
end
