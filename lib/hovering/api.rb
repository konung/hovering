require 'dry/validation'
require 'reform'
require 'trailblazer'
require 'hovering/macro'
require 'hovering/client'
require 'hovering/errors'

module Hovering
  class Api
    class ApiError < StandardError; end

    # This is a model-less operation, so using pre-operation schema validation to check if all params are supplied
    class Get < Trailblazer::Operation
      extend Contract::DSL

      CheckParamsSchema = Dry::Validation.Schema do
        required(:client).filled
        required(:endpoint).filled
      end

      contract "params", CheckParamsSchema

      step Contract::Validate( name: "params" ), before: "operation.new"
      # This will be run a as class method, not instance,  because of the guard condition above
      failure Hovering::Macro::HandleDryValidationErrors(schema: CheckParamsSchema)

      step Hovering::Macro::MakeApiCall(action: 'get')
      failure Hovering::Macro::HandleError(error: ApiError, message: "Can't make a call to to Hover.com API")

      step Hovering::Macro::CheckResponseValidJson()
      failure Hovering::Macro::HandleError(error: ApiError, message: "Response is not valid JSON")

      step Hovering::Macro::CheckApiResponseForErrors()
      failure Hovering::Macro::HandleError(error: ApiError, message: 'Something happened during an API call')
    end


    class Delete < Trailblazer::Operation
      extend Contract::DSL

      CheckParamsSchema = Dry::Validation.Schema do
        required(:id).filled
        required(:client).filled
        required(:endpoint).filled
      end

      contract "params", CheckParamsSchema

      step Contract::Validate( name: "params" ), before: "operation.new"
      # This will be run a as class method, not instance,  because of the guard condition above
      failure Hovering::Macro::HandleDryValidationErrors(schema: CheckParamsSchema)

      step Hovering::Macro::MakeApiCall(action: 'delete')
      #failure Hovering::Macro::HandleError(error: ApiError, message: "Can't make a call to to Hover.com API")

      step Hovering::Macro::CheckResponseValidJson()
      #failure Hovering::Macro::HandleError(error: ApiError, message: "Response is not valid JSON")

      step Hovering::Macro::CheckApiResponseForErrors()
      failure Hovering::Macro::HandleError(error: ApiError, message: 'Something happened during an API call')
    end

  end
end
