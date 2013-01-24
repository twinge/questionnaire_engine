require 'spec_helper'

describe Qe::Answer do
  it { should have_db_column :answer_sheet_id }
  it { should have_db_column(:value) }
  it { should have_db_column(:short_value) }
  it { should have_db_column(:size) }
  it { should have_db_column(:content_type) }
  it { should have_db_column(:filename) }
  it { should have_db_column(:height) }
  it { should have_db_column(:width) }
  it { should have_db_column(:parent_id) }
  it { should have_db_column(:thumbnail) }
  it { should have_db_index :short_value }
  
  it { should belong_to :answer_sheet }
end
