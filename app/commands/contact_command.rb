class ContactCommand
  attr_reader :contact, :errors
  def initialize(contact_params)
    @contact = Contact.new(contact_params)
    @errors = nil
  end

  def create
    Contact.transaction do
      if contact.save
        hydrate_topics
        true
      else
        @errors = contact.errors.full_messages.join(', ')
        false
      end
    end
  rescue SocketError => e
    @errors = e.message
    false
  end

  def errors
    "Error: #{@errors}" if @errors
  end

  private

  def hydrate_topics
    WebScraper.new(contact.url, contact.id).call
  end
end
