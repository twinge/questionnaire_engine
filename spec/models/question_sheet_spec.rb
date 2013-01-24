require 'spec_helper'

describe Qe::QuestionSheet do
  it { should have_db_column(:label) }
  it { should have_db_column(:archived) }
end
