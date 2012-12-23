require 'spec_helper'

describe Qe::Condition do
  it { should have_db_column :qe_question_sheet_id }
  it { should belong_to :qe_question_sheet }

  it { should have_db_column(:trigger_id).of_type(:integer)     }
  it { should have_db_column(:expression).of_type(:string)      }
  it { should have_db_column(:toggle_page_id).of_type(:integer) }
  it { should have_db_column(:toggle_id).of_type(:integer)      }
end
