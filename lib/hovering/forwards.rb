module Hovering
  class ForwardError < StandardError; end
  class DomainForward < OpenStruct; end
  class Forward < OpenStruct; end

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

  class DomainForwardRepresenter < Roar::Decorator
    include Roar::JSON
    property   :domain_name,  type: String
    collection :forwards, extend: ForwardRepresenter, class: Forward
  end

  class AccountForwardRepresenter < Roar::Decorator
    include Roar::JSON
    property :succeded, type: Axiom::Types::Boolean
    collection :domains, extend: DomainForwardRepresenter, class: DomainForward
  end

  class Forward < OpenStruct
    class Delete < Trailblazer::Operation
      extend Representer::DSL
      representer ForwardRepresenter
      step ->(options){ puts "Deleteing " + options["params"][:id].to_s; true}
      failure Hovering::Macro::HandleError(error: ForwardError, message: "Can't delete forwarding / redirect")
    end
  end


  class AccountForward < OpenStruct
    class List < Trailblazer::Operation
      extend Representer::DSL
      representer AccountForwardRepresenter
      step Model(AccountForward, :new)
      step ->(options, params){ options['hovering.api_call.response.raw'] = Hovering::Api::Get.(client: params[:params][:client], endpoint: 'forwards')['model']}
      step Hovering::Macro::ParseApiResponse()
      failure Hovering::Macro::HandleError(error: ForwardError, message: "Can't list / get account forwards")
    end
  end
end
