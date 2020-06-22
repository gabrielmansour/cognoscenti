require 'rails_helper'

RSpec.describe Contact do
  subject { build_stubbed(:contact) }

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
      it { is_expected.to_not be_persisted }
      its(:shorten_url) { is_expected.to be_nil }
    end

    context 'when URL is populated' do
      let(:url) { 'https://example.com' }
      its(:shortened_url) { is_expected.to be_present }
      its(:shortened_url) { is_expected.to match URI.regexp }
      it { is_expected.to be_persisted }
    end
  end
end
