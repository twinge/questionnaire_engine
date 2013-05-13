require 'spec_helper'

describe Qe::ReferenceSheet do 
  
  it { should belong_to :question }
  it { should belong_to :applicant_answer_sheet }
  xit { should validate_presence_of :first_name }

end