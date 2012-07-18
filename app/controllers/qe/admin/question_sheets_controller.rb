# Qe::QuestionSheets is used exclusively on the administration side to design a Questionniare
#  which can than be instantiated as an AnswerSheet for data capture on the front-end

module Qe
  class Admin::QuestionSheetsController < ApplicationController
    include Qe::Concerns::Controllers::QuestionSheetsController
  end
end