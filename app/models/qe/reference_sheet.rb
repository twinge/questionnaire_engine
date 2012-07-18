module Qe
  class ReferenceSheet < AnswerSheet
    # should be required within the concerns included module
    # include Rails.application.routes.url_helpers
    
    include Qe::Concerns::Models::ReferenceSheet
  end
end
