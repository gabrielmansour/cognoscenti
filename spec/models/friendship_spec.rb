require 'rails_helper'

RSpec.describe Friendship do
  it { is_expected.to belong_to(:contact) }
  it { is_expected.to belong_to(:friend).class_name('Contact') }

  describe '.between' do
    subject { described_class.between(user1, user2) }

    let(:user1) { 11 }
    let(:user2) { 22 }

    it 'finds all friendships between the two users' do
      relation = Friendship.where(contact: user1, friend: user2)
      inverse = Friendship.where(contact: user2, friend: user1)
      is_expected.to eq relation.or(inverse)
    end
  end

  describe '.including' do
    subject { described_class.including(contact) }

    let(:contact) { create(:contact) }

    it 'finds all friendships including the contact' do
      f1 = create(:friendship, contact: contact)
      f2 = create(:friendship, friend: contact)
      is_expected.to match_array [f1, f2]
    end
  end
end
