require 'spec_helper'

describe Qe::QuestionSheet do
  it { should have_db_column(:label) }
  it { should have_db_column(:archived) }

  it { should have_many :pages }
  it { should have_many :questions }

end
