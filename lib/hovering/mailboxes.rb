module Hovering
  # At this point it just for reading this end-point only
  # I don't use Email feature of Hover, so I don't know what it involves.

  class Mailbox < OpenStruct; end
  class DomainMailboxes < OpenStruct; end
  class AccountMailboxes < OpenStruct; end

  class MailboxRepresenter < Roar::Decorator
    include Roar::JSON
    include Roar::Coercion

    property :id,        type: String
  end

  class DomainMailboxesRepresenter < Roar::Decorator
    include Roar::JSON
    include Roar::Coercion

    property :domain_name, type: String
    property :num_unused,  type: Integer
    collection :mailboxes, extend: MailboxRepresenter, class: Mailbox
  end

  class AccountMailboxesRepresenter < Roar::Decorator
    include Roar::JSON
    property :succeded, type: Axiom::Types::Boolean
    property :mailboxes, type: Array
    property :can_create, type: Axiom::Types::Boolean
    collection :mailbox_domains, extend: DomainMailboxesRepresenter, class: DomainMailboxes
  end
end
