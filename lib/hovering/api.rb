require 'trailblazer'
require 'reform'
require 'reform/form/active_model/validations'
Reform::Form.class_eval do
  include Reform::Form::ActiveModel::Validations
end

require 'hovering/macro'
require 'hovering/client'
require 'hovering/errors'

module Hovering
  class Api
    class ApiError < StandardError; end



    # This is a model-less operation, so using pre-operation schema validation to check if all params are supplied
    class Get < Trailblazer::Operation
      class Form < Reform::Form
        property :id
        property :client
        property :endpoint
        validates :client, presence: true
        validates :endpoint, presence: true
      end
      step Contract::Build( constant: Form )
      step Contract::Validate(), before: "operation.new"
      step Contract::Validate()
      step Hovering::Macro::MakeApiCall(action: 'get')
      fail Hovering::Macro::HandleError(error: ApiError, message: "Can't make a call to to Hover.com API")
      step Hovering::Macro::CheckResponseValidJson()
      fail Hovering::Macro::HandleError(error: ApiError, message: "Response is not valid JSON")
      step Hovering::Macro::CheckApiResponseForErrors()
      fail Hovering::Macro::HandleError(error: ApiError, message: 'Something happened during an API call')
    end


    class Delete < Trailblazer::Operation
      class Form < Reform::Form
        property :id
        property :client
        property :endpoint
        validates :id, presence: true
        validates :client, presence: true
        validates :endpoint, presence: true
      end
      step Contract::Build( constant: Form )
      step Contract::Validate( name: "params" ), before: "operation.new"
      step Contract::Validate()
      step Hovering::Macro::MakeApiCall(action: 'delete')
      step Hovering::Macro::CheckResponseValidJson()
      step Hovering::Macro::CheckApiResponseForErrors()
      fail Hovering::Macro::HandleError(error: ApiError, message: 'Something happened during an API call')
    end

  end
end
