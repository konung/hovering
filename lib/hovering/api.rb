require 'trailblazer'
require 'hovering/client'
require 'hovering/errors'

module Hovering
  class Api
    class ApiError < StandardError; end

    class Get < Trailblazer::Operation
      step :check_params
      failure :handle_no_params
      step :make_api_call
      failure :handle_connection_error
      step :check_if_response_is_valid_json
      failure :handle_invalid_json_error
      step :check_if_response_is_error_response
      failure :handle_error_response

      def check_params(options, params:, **)
        params.dig('client') && params.dig('endpoint')
      end

      def make_api_call(options, params:, **)
        options['model'] = params['client'].connection(params['endpoint'])&.get&.body
      end

      def check_if_response_is_valid_json(options, params:, **)
        begin
          JSON.parse(options['model'])
          return true
        rescue JSON::ParserError => e
          return false
        end
      end

      def check_if_response_is_error_response(options, params:, **)
        options['api_response'] = Hovering::ErrorRepresenter.new(Hovering::Error.new).from_json(options['model'])
        options['api_response'].succeeded
      end

      def handle_no_params(options, **)
        raise ApiError, "Missing params 'client' or 'endpoint'"
      end
      def handle_connection_error(options, **)
        raise ApiError, "Can't make a call to to Hover.com API"
      end
      def handle_invalid_json_error(options, **)
        raise ApiError, "Response is not valid JSON"
      end
      def handle_error_response(options, **)
        raise ApiError, options['api_response']
      end
    end
  end
end
