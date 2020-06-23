class FriendshipsController < ApplicationController
  def create
    FriendshipCommand.create(contact, friend_id)
    flash[:notice] = 'You made a new friend!'
  rescue
    flash[:warning] = 'You two are already friends!'
  ensure
    redirect_to contact
  end

  def destroy
    FriendshipCommand.unfriend(contact, friend_id)
    redirect_to contact, notice: 'So long, old friend.'
  end

  private

  def contact
    @contact ||= Contact.find(params.require(:contact_id))
  end

  def friend_id
    params.require(:friend_id)
  end
end
