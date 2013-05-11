require 'spec_helper'

describe Qe::Question do 
  it { should have_many :conditions }
  it { should have_many :sheet_answers }
  xit { should belong_to :related_question_sheet }

  
  let(:question) { FactoryGirl.create(:question) }

  it '#default_label?' do 
    question.default_label?.should be_true
  end

  xit '#response'
  xit '#display_response'
  xit '#responses'
  xit '#set_responses'
  xit '#save_file'
  xit '#save_response'
  xit '#has_response'
  xit '#required?'
end
