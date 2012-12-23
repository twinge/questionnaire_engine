require 'spec_helper'

describe Qe::QuestionSheet do
  it { should have_db_column(:label).of_type(:string)     }
  it { should have_db_column(:archived).of_type(:boolean) }
end
