module Hovering
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
end
