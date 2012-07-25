# should be required with lib/qe.rb
# require_dependency 'qe/presenter'

module Qe
  class AnswerPagesPresenter < Presenter
    include Qe::Concerns::Presenters::AnswerPagesPresenter
  end
end