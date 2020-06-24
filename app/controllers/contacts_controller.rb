class ContactsController < ApplicationController
  def index
    @contacts = Contact.includes(:topics)
  end

  def new
    @contact = Contact.new(params[:contact])
  end

  def create
    command = ContactCommand.new(contact_params)
    @contact = command.contact
    if command.create
      redirect_to @contact, notice: 'Contact created successfully'
    else
      flash[:error] = command.errors.to_s
      render :new
    end
  end

  def show
    @contact = Contact.find(params[:id])
    if params[:q].present?
      @results = SearchQuery.new(@contact).call(params[:q], sort: params[:sort])
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :url)
  end
end
