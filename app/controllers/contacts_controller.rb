class ContactsController < ApplicationController
  def index
    @contacts = Contact.includes(:topics)
  end

  def new
    @contact = Contact.new(params[:contact])
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      redirect_to @contact, notice: 'Contact created successfully'
    else
      render :new
    end
  end

  def show
    @contact = Contact.find(params[:id])
    if params[:q].present?
      @results = []
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :url)
  end
end
