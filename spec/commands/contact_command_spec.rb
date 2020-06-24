require 'rails_helper'

RSpec.describe ContactCommand do
  subject { described_class.new(contact_params) }
  let(:contact_params) { attributes_for(:contact) }

  its(:contact) { is_expected.to be_a_new Contact }
  its(:errors) { is_expected.to be_nil }

  describe '#create' do
    context 'when successfully saved' do
      it 'persists the new Contact', vcr: true do
        expect { subject.create }.to change(Contact, :count).from(0).to(1)
      end

      it 'hydrates the Topics for the contact', vcr: true do
        expect { subject.create }.to change(Topic, :count).from(0).to(23)
      end

      it 'return true', vcr: true do
        expect(subject.create).to eq true
      end

      it 'produces no errors' do
        subject.create
        expect(subject.errors).to be_nil
      end
    end

    context 'when record invalid' do
      let(:contact_params) { {} }

      it 'does not persist the contact' do
        expect { subject.create }.to_not change(Contact, :count).from(0)
      end

      it 'does not create any Topics' do
        expect { subject.create }.to_not change(Topic, :count).from(0)
      end

      its(:create) { is_expected.to eq false }

      it 'produces errors' do
        subject.create
        expect(subject.errors).to eq "Error: Name can't be blank, Url can't be blank, Url is invalid"
      end
    end

    context 'when there is a problem accessing the website' do
      let(:contact_params) { attributes_for(:contact, url: url) }
      let(:url) { 'http://fake.invalid.fake' }

      before do
        expect_any_instance_of(WebScraper).to receive(:open).with(url)
          .and_raise(SocketError, 'cannot open fake.invalid.fake')
      end

      it 'does not raise an error' do
        expect { subject.create }.to_not raise_error
      end

      it 'does not add any Topics' do
        expect { subject.create }.to_not change(Topic, :count).from(0)
      end

      its(:create) { is_expected.to eq false }

      it 'does not persist the contact' do
        expect { subject.create }.to_not change(Contact, :count).from(0)
      end

      it 'does not create any Topics' do
        expect { subject.create }.to_not change(Topic, :count).from(0)
      end

      it 'has errors' do
        subject.create
        expect(subject.errors).to eq 'Error: cannot open fake.invalid.fake'
      end
    end
  end
end
