require 'spec_helper'

describe Qe::AnswerSheetQuestionSheet do 
  it { should belong_to :answer_sheet }
  it { should belong_to :question_sheet }
end