require 'spec_helper'

describe Qe::Answer do 
  it { should belong_to :answer_sheet }
  it { should belong_to :question }

  it { should validate_presence_of :value }
  xit '{ should validate max length = 255 }'

  xit '#set'
  xit '#to_s'
  xit '#set_value_from_filename'
end