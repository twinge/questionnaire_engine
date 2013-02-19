require 'spec_helper'

describe Qe::Answer do
  it { should have_db_column :answer_sheet_id }
  it { should have_db_column(:value) }
  it { should have_db_column(:short_value) }
  
  it { should belong_to :answer_sheet }
  it { should belong_to :question }
end
