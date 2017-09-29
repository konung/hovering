module Hovering

  class Forward < OpenStruct; end
  class DomainForwards < OpenStruct; end
  class AccountForwards < OpenStruct; end

  class ForwardRepresenter < Roar::Decorator
    include Roar::JSON
    include Roar::Coercion

    property :id,        type: String
    property :url,       type: String
    property :path,      type: String
    property :link_url,  type: String
    property :subdomain, type: Axiom::Types::Boolean
    property :stealth,   type: Axiom::Types::Boolean
  end

  class DomainForwardsRepresenter < Roar::Decorator
    include Roar::JSON
    property   :domain_name,  type: String
    collection :forwards, extend: ForwardRepresenter, class: Forward
  end

  class AccountForwardsRepresenter < Roar::Decorator
    include Roar::JSON
    property :succeded, type: Axiom::Types::Boolean
    collection :domains, extend: DomainForwardsRepresenter, class: DomainForwards
  end
end
