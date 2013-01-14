require 'spec_helper'

describe Qe::Condition do
  it { should have_db_column :question_sheet_id }
  it { should have_db_column(:trigger_id).of_type(:integer)     }
  it { should have_db_column(:expression).of_type(:string)      }
  it { should have_db_column(:toggle_page_id).of_type(:integer) }
  it { should have_db_column(:toggle_id).of_type(:integer)      }

  it { should belong_to :question_sheet }
end
