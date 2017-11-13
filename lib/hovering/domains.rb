require 'hovering/contacts'
require 'hovering/forwards'
require 'hovering/dns_records'
require 'hovering/mailboxes'

module Hovering

  class Domain < OpenStruct; end
  class AccountDomain < OpenStruct; end

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
    collection :forwards, decorator: ForwardRepresenter, class: Forward
    collection :entries, decorator: DnsRecordRepresenter, class: DnsRecord
    collection :mailboxes, decorator: MailboxRepresenter, class: Mailbox
  end

  class AccountDomainRepresenter < Roar::Decorator
    include Roar::JSON
    property :succeeded, type: Axiom::Types::Boolean
    collection :domains, extend: DomainRepresenter, class: Domain
    property :can_create, type: Axiom::Types::Boolean
    collection :mailbox_domains, extend: DomainMailboxesRepresenter, class: DomainMailboxes
  end
end
