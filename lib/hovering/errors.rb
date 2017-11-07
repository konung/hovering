module Hovering

  class Error < OpenStruct; end

  class Errors < OpenStruct; end

  class ErrorRepresenter < Roar::Decorator
    include Roar::JSON
    property :error_code
    property :error
    property :status
    property :succeded
  end

  class ErrorsRepresenter < Roar::Decorator
    include Roar::JSON
    collection :errors, extend: ErrorRepresenter, class: Error
  end
end
