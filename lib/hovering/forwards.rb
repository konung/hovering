module Macro
  def self.GetCallTo(endpoint: )
    step = ->(input, options) do
      options["hovering.api_call.response"] = Hovering::Api::Get.({'client' => options['params']['client'], 'endpoint' =>  endpoint})['model']
    end
    [ step, name: "hovering.api_call.#{endpoint}" ]
  end

  def self.ParseApiResponse()
    step = ->(input, options) do
      options['model'] = options['representer.default.class'].new(options['model.class'].new).from_json(options['hovering.api_call.response'])
    end
    [ step, name: "hovering.api_call.parsing" ]
  end

  def self.HandleError(error: StandardError, message: 'Hovering Error')
    step = ->(input, options) do
      raise error, message
    end
    [ step, name: "hovering.handle_error" ]
  end
end

module Hovering

  class ForwardError < StandardError; end
  class Forward < OpenStruct; end
  class DomainForward < OpenStruct; end
  class AccountForward < OpenStruct; end

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

  class AccountForward
    class List < Trailblazer::Operation
      extend Representer::DSL
      representer AccountForwardRepresenter
      step Model(AccountForward, :new)
      step Macro.GetCallTo(endpoint: 'forwards')
      step Macro.ParseApiResponse()
      failure Macro.HandleError(error: ForwardError, message: "Can't list / get account forwards")
    end
  end
end
