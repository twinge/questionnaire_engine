# should be taken care of in lib/qe.rb
# require_dependency "qe/application_controller"
# require_dependency "qe/answer_sheets_controller"

module Qe
  class ReferenceSheetsController < AnswerSheetsController
    include Qe::Concerns::Controllers::ReferenceSheetsController
  end
end
