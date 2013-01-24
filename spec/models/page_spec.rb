require 'spec_helper'

describe Qe::Page do
  it { should have_db_column(:question_sheet_id) }
  it { should belong_to :question_sheet }
  it { should have_db_column(:label) }
  it { should have_db_column(:number) }
  it { should have_db_column(:no_cache) }
  it { should have_db_column(:hidden) }

  it { should have_many :page_elements  }
  it { should have_many :elements       }
end
