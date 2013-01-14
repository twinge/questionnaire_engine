require 'spec_helper'

describe Qe::AnswerSheet do
  it { should have_db_column(:question_sheet_id).of_type(:integer) }
  it { should have_db_column(:completed_at).of_type(:datetime) }

  it { should belong_to :question_sheet }
end
