require 'hovering/contacts'

module Hovering

  class Domain < OpenStruct; end
  class AccountDomains < OpenStruct; end

  class DomainRepresenter < Roar::Decorator
    include Roar::JSON
    include Roar::Coercion

    property :id,              type: String
    property :domain_name,     type: String
    property :num_emails,      type: Integer
    property :renewal_date,    type: Date
    property :display_date,    type: Date
    property :registered_date, type: Date
    property :status,          type: String
    property :auto_renew,      type: Axiom::Types::Boolean
    property :renewable,       type: Axiom::Types::Boolean
    property :locked,          type: Axiom::Types::Boolean
    property :whois_privacy,   type: Axiom::Types::Boolean
    property :nameservers,     type: Array
    property :dnssec
    property :glue
    property :hover_user , class: OpenStruct do
      property :email, type: String
      property :email_secondary, type: String
      property :billing , class: OpenStruct do
        property :pay_mode, type: String
        property :paypal_email, type: String
      end
    end
    property :contacts, decorator: ContactsRepresenter, class: Contacts
  end

  class AccountDomainsRepresenter < Roar::Decorator
    include Roar::JSON
    property :succeded
    collection :domains, extend: DomainRepresenter, class: Domain
  end
end
