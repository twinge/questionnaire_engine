require 'spec_helper'

describe Qe::Condition do
  it { should have_db_column :question_sheet_id }
  it { should have_db_column(:trigger_id) }
  it { should have_db_column(:expression) }
  it { should have_db_column(:toggle_page_id) }
  it { should have_db_column(:toggle_id) }

  it { should belong_to :question_sheet }
end
