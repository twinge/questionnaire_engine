require 'spec_helper'

describe Qe::AnswerSheet do
  it { should have_db_column(:qe_question_sheet_id).of_type(:integer) }

  it { should belong_to :qe_question_sheet }

  it { should have_db_column(:completed_at).of_type(:datetime) }
end
