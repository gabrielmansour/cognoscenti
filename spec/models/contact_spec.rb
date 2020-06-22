require 'rails_helper'

RSpec.describe Contact do
  subject { build_stubbed(:contact) }

  it { is_expected.to have_many(:topics).dependent(:destroy) }

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
    before { subject.save }

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
end
