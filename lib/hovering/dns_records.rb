module Hovering

  class DnsRecord  < OpenStruct; end
  class DomainDns  < OpenStruct; end
  class AccountDns < OpenStruct; end

  class DnsRecordRepresenter < Roar::Decorator
    include Roar::JSON
    include Roar::Coercion

    property :id,         type: String
    property :name,       type: String
    property :status,     type: String
    property :type,       type: String
    property :content,    type: String
    property :ttl,        type: Integer
    property :is_default, type: Axiom::Types::Boolean
    property :can_revert, type: Axiom::Types::Boolean
  end

  class DomianDnsRepresenter < Roar::Decorator
    include Roar::JSON
    property :succeded, type: Axiom::Types::Boolean
    property :domain_name, type: String
    property :id, type: String
    property :active, type: Axiom::Types::Boolean
    collection :entries, extend: DnsRecordRepresenter, class: DnsRecord
  end

  class AccountDnsRepresenter < Roar::Decorator
    include Roar::JSON
    property :succeded, type: Axiom::Types::Boolean
    collection :domains, extend: DomianDnsRepresenter, class: DomainDns
  end
end
