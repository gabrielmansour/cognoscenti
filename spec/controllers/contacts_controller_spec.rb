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

  describe '#show' do
    let(:contact) { create(:contact) }
    it 'shows the details page for the given contact' do
      get :show, params: { id: contact.id }
      expect(assigns(:contact)).to eq contact
      expect(assigns(:results)).to be_nil
    end

    context 'when there is a search query provided' do
      let(:search_query) { double(:search_query) }
      let(:search_results) { double(:search_results) }

      before do
        allow(SearchQuery).to receive(:new).with(contact).and_return(search_query)
        allow(search_query).to receive(:call).with('life', sort: 'expertise') { search_results }
      end

      it 'shows the details page for the given contact' do
        get :show, params: { id: contact.id, q: 'life', sort: 'expertise' }
        expect(assigns(:contact)).to eq contact
        expect(assigns(:results)).to eq search_results
      end
    end
  end
end
