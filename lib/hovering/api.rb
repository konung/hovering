require 'dry/validation'
require 'reform'
require 'reform/form/dry'
require 'reform/form/coercion'
require 'trailblazer'
require 'hovering/macro'
require 'hovering/client'
require 'hovering/errors'

module Hovering
  class Api
    class ApiError < StandardError; end


    # This is a model-less operation, so using pre-operation schema validation to check if all params are supplied
    class Get < Trailblazer::Operation
      class GetForm < Reform::Form
        include Reform::Form::Module
        include Reform::Form::Coercion
        feature Reform::Form::Dry
        feature Reform::Form::Coercion
        property :id, type: Types::Coercible::String
        property :client, type: Types::Coercible::String
        property :endpoint, type: Types::Coercible::String

      validation name: :default do
          required(:id).maybe
          required(:client).filled
          required(:endpoint).filled
        end
      end

      step Contract::Build( constant: GetForm )
      step Contract::Validate(), before: "operation.new"
      step Contract::Validate()
      step Hovering::Macro::MakeApiCall(action: 'get')
      failure Hovering::Macro::HandleError(error: ApiError, message: "Can't make a call to to Hover.com API")
      step Hovering::Macro::CheckResponseValidJson()
      failure Hovering::Macro::HandleError(error: ApiError, message: "Response is not valid JSON")
      step Hovering::Macro::CheckApiResponseForErrors()
      failure Hovering::Macro::HandleError(error: ApiError, message: 'Something happened during an API call')
    end


    class Delete < Trailblazer::Operation
      class DeleteForm < Reform::Form
        include Reform::Form::Module
        include Reform::Form::Coercion
        feature Reform::Form::Dry
        feature Reform::Form::Coercion
        property :id, type: Types::Coercible::String
        property :client, type: Types::Coercible::String
        property :endpoint, type: Types::Coercible::String

        validation name: :default do
          required(:id).filled
          required(:client).filled
          required(:endpoint).filled
        end
      end

      step Contract::Build( constant: DeleteForm )
      step Contract::Validate( name: "params" ), before: "operation.new"
      step Contract::Validate()
      step Hovering::Macro::MakeApiCall(action: 'delete')
      step Hovering::Macro::CheckResponseValidJson()
      step Hovering::Macro::CheckApiResponseForErrors()
      failure Hovering::Macro::HandleError(error: ApiError, message: 'Something happened during an API call')
    end

  end
end
