module Hovering

  class Contact < OpenStruct; end

  class Contacts < OpenStruct; end

  class ContactRepresenter < Roar::Decorator
    include Roar::JSON
    include Roar::Coercion
    property :status, type: String
    property :org_name, type: String
    property :first_name, type: String
    property :last_name, type: String
    property :phone, type: String
    property :fax, type: String
    property :email, type: String
    property :address1, type: String
    property :address2, type: String
    property :address3, type: String
    property :city, type: String
    property :state, type: String
    property :zip, type: String
    property :country, type: String
  end

  class ContactsRepresenter < Roar::Decorator
    include Roar::JSON
    property :admin, decorator: ContactRepresenter, class: Contact
    property :owner, decorator: ContactRepresenter, class: Contact
    property :tech, decorator: ContactRepresenter, class: Contact
    property :billing, decorator: ContactRepresenter, class: Contact
  end

  class Contact::Create < Trailblazer::Operation
    step :here
    def here(options, **)
      puts 'here'
    end
  end
end
