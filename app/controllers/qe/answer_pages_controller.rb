# should be taken care of in because of requires in lib/qe.rb

module Qe
  class AnswerPagesController < ApplicationController
     include Qe::Concerns::Controllers::AnswerPagesController
   end
 end
