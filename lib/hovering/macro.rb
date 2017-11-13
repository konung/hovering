module Hovering
  module Macro
    def self.GetCallTo(endpoint: )
      step = ->(input, options) do
        options["hovering.api_call.response.raw"] = Hovering::Api::Get.({'client' => options['params']['client'], 'endpoint' =>  endpoint})['model']
      end
      [ step, name: "hovering.api_call.#{endpoint}" ]
    end

    def self.ParseApiResponse()
      step = ->(input, options) do
        options['model'] = options['representer.default.class'].new(options['model.class'].new).from_json(options['hovering.api_call.response.raw'])
      end
      [ step, name: "hovering.api_call.parsing" ]
    end

    def self.HandleError(error: StandardError, message: 'Hovering Error')
      step = ->(input, options) do
        msg = message
        msg = options['hovering.api_call.response.parsed'] if options['hovering.api_call.response.parsed']
        raise error, msg
      end
      [ step, name: "hovering.handle_error" ]
    end

    def self.HandleDryValidationErrors(schema: )
      step = ->(input, options) do
        check_result = schema.call(options['params'])
        options['contract.errors'] = check_result.errors
      end
      [ step, name: "contract.validate.handle_dry_validation_errors" ]
    end

    ##################

    def self.MakeApiCall(action: )
      step = ->(input, options) do
        #ap options
        begin
          unless options['hovering.api_call.response.raw']
            options['model'] = options['hovering.api_call.response.raw'] = options['params'][:client].connection(options['params'][:endpoint]).send(action).body
          end
        rescue StandardError => e
          raise " Error in Macro::MakeApiCall #{e.message}"
        end
      end
      [ step, name: "hovering.api_call.#{action}" ]
    end

    def self.CheckResponseValidJson()
      step = ->(input, options) do
        begin
          JSON.parse(options['hovering.api_call.response.raw'])
          return true
        rescue JSON::ParserError => e
          return false
        end
      end
      [ step, name: "hovering.api_call.validate_json" ]
    end

    def self.CheckApiResponseForErrors()
      step = ->(input, options) do
        options['hovering.api_call.response.parsed'] = Hovering::ErrorRepresenter.new(Hovering::Error.new).from_json(options['hovering.api_call.response.raw'])
        options['hovering.api_call.response.parsed'].succeeded
      end
      [ step, name: "hovering.api_call.error" ]
    end

  end
end
