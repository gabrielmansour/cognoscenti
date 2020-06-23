require 'rails_helper'

RSpec.describe FriendshipCommand do
  let(:contact1) { create(:contact, name: 'Al') }
  let(:contact2) { create(:contact, name: 'Bo') }
  let(:records) { Friendship.all }
  let(:friendship_friends) { records.map { |f| [f.contact, f.friend] } }

  describe '.create' do
    subject { described_class.create(contact1, contact2) }

    it 'creates a bi-directional friendship association' do
      expect { subject }.to change(Friendship, :count).from(0).to(2)

      expect(friendship_friends).to match_array [[contact1, contact2], [contact2, contact1]]
    end
  end

  describe '.unfriend' do
    subject { described_class.unfriend(contact1, contact2) }

    let(:contact3) { create(:contact, name: 'Co') }

    before do
       FriendshipCommand.create(contact1, contact2)
       FriendshipCommand.create(contact1, contact3)
       FriendshipCommand.create(contact2, contact3)
    end

    it 'bi-directionally destroys any friendship between the two contacts' do
      expect { subject }.to change(Friendship, :count).from(6).to(4)
    end

    it 'does not delete other friendships' do
      subject
      expect(friendship_friends).to match_array [
        [contact1, contact3], [contact3, contact1],
        [contact2, contact3], [contact3, contact2]
      ]
    end
  end
end
