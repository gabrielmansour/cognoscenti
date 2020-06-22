require 'rails_helper'

RSpec.describe ContactsController do
  describe '#index' do
    before { get :index }
    it { is_expected.to render_template('contacts/index') }
  end

  describe '#new' do
    before { get :new }
    it { is_expected.to render_template('contacts/new') }
    it { expect(assigns(:contact)).to be_a_new(Contact) }
  end

  describe '#create' do
    before { post :create, params: params }
    let(:params) { { contact: { name: 'Joe', url: 'http://example.com', shortened_url: 'https://shorty.ca' } } }
    let(:contact) { Contact.last }

    context 'valid input' do
      it 'creates a new Contact using the Name and URL' do
        expect(Contact.count).to eq 1
        expect(contact.name).to eq 'Joe'
        expect(contact.url).to eq 'http://example.com'
        expect(contact.shortened_url).to be_present
        expect(contact.shortened_url).to_not eq 'https://shorty.ca'
      end

      it 'redirects to the newly create contact page' do
        is_expected.to redirect_to contact_path(contact)
      end
    end

    context 'invalid input' do
      let(:params) { { contact: { name: '' } } }
      it 'does not create a Contact' do
        expect(Contact.count).to eq 0
      end
      it { is_expected.to render_template('contacts/new') }
    end
  end
end
