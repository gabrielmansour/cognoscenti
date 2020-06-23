require 'rails_helper'

RSpec.describe Contact do
  subject { build_stubbed(:contact) }

  it { is_expected.to have_many(:topics).dependent(:destroy) }
  it { is_expected.to have_many(:friendships).dependent(:destroy) }
  it { is_expected.to have_many(:friends).through(:friendships) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:url) }
  it { is_expected.to validate_presence_of(:shortened_url) }

  context 'with all attributes filled in properly' do
    it { is_expected.to be_valid }
  end

  it_behaves_like 'url field', :url
  it_behaves_like 'url field', :shortened_url

  describe 'after create' do
    subject { build(:contact, :from_form, url: url) }
    let(:url) { '' }
    before do
      allow(ShortURL).to receive(:shorten).and_call_original
      allow_any_instance_of(WebScraper).to receive(:call).and_call_original

      subject.save
    end

    context 'when URL is blank' do
      before { expect(ShortURL).to_not receive(:shorten) }
      it { is_expected.to_not be_persisted }
      its(:shorten_url) { is_expected.to be_nil }

      it 'does not create any Topics' do
        expect(Topic.count).to eq 0
      end
    end

    context 'when URL is populated' do
      let(:url) { 'http://example.com' }
      its(:shortened_url) { is_expected.to eq 'http://tinyurl.com/ya599baa' }
      its(:shortened_url) { is_expected.to match URI.regexp }
      it(vcr: true) { is_expected.to be_persisted }

      it 'creates Topics for the Contact' do
        expect(Topic.count).to eq 23
      end
    end
  end

  describe '.not_friends_with' do
    subject { Contact.not_friends_with(contacts[0]) }
    let(:contacts) { create_list(:contact, 4) }

    context 'no friends' do
      it 'lists all contacts with whom I am not friends with yet' do
        is_expected.to match_array contacts.from(1)
      end
    end

    context 'when other people are friends' do
      before { FriendshipCommand.create(contacts[1], contacts[2]) }
      it 'lists all contacts with whom I am not friends with yet' do
        is_expected.to match_array contacts.from(1)
      end
    end

    context 'some friends' do
      before do
        FriendshipCommand.create(contacts[0], contacts[1])
        FriendshipCommand.create(contacts[0], contacts[3])
      end
      it { is_expected.to eq [contacts[2]] }
    end

    context 'friends with everyone' do
      before do
        1.upto(3) { |i| FriendshipCommand.create(contacts[0], contacts[i]) }
      end
      it { is_expected.to eq [] }
    end
  end
end
