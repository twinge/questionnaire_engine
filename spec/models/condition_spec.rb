require 'spec_helper'

describe Qe::Condition do 
  it { should belong_to :question_sheet }
  it { should belong_to :trigger }

  it { should validate_presence_of :expression }
  xit 'validate max length = 255'

  xit '#trigger_js'
  xit '#evaluate'
end