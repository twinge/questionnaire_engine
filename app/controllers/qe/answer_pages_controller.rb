# should be taken care of in because of requires in lib/qe.rb
# require_dependency "qe/application_controller"
# require_dependency "qe/answer_pages_presenter"



module Qe
  class AnswerPagesController < ApplicationController
     include Qe::Concerns::Controllers::AnswerPagesController
   end
 end
