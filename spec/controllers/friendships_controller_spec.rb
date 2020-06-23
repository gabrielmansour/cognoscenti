require 'rails_helper'

RSpec.describe FriendshipsController do
  subject { make_request && response }
  let(:make_request) { post(:create, params: params) }
  let(:params) { { contact_id: contact.id, friend_id: friend.id } }
  let(:contact) { create(:contact) }
  let(:friend) { create(:contact) }
  let(:relation) { Friendship.between(contact, friend) }

  describe '#create' do
    it 'creates a new bi-directional friendship' do
      expect { subject }.to change(relation, :count).from(0).to(2)
    end

    it { is_expected.to redirect_to contact_path(contact) }

    it 'flashes a notice' do
      subject
      expect(flash[:notice]).to eq "You made a new friend!"
    end

    context 'when friendship already exists' do
      before { FriendshipCommand.create(contact, friend) }

      it { is_expected.to redirect_to contact_path(contact) }

      it 'does not alter the records' do
        expect { subject }.to_not change(relation, :count).from(2)
      end

      it 'flashes a notice' do
        subject
        expect(flash[:warning]).to eq "You two are already friends!"
      end
    end
  end

  describe '#destroy' do
    let(:make_request) { delete(:destroy, params: params) }

    context 'when friendship exists' do
      before { FriendshipCommand.create(contact, friend) }

      it { is_expected.to redirect_to contact_path(contact) }

      it 'deletes the friendship bi-directionally between the two users' do
          expect { subject }.to change(relation, :count).from(2).to(0)
      end

      it 'flashes' do
        subject
        expect(flash[:notice]).to eq 'So long, old friend.'
      end
    end

    context 'when friendship does not exist' do
      it { is_expected.to redirect_to contact_path(contact) }

      it 'does not delete anything' do
        expect { subject }.to_not change(relation, :count).from(0)
      end
    end
  end
end
