require 'spec_helper'

describe Qe::ReferenceSheet do
  it { should belong_to :applicant_answer_sheet }
end

