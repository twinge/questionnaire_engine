require 'spec_helper'
require 'qe/page_element'

describe Qe::Page do
  it { should have_db_column(:qe_question_sheet_id).of_type(:integer) }
  it { should belong_to :qe_question_sheet }
  it { should have_many :qe_page_elements  }
  it { should have_many :qe_elements       }

  it { should have_db_column(:label).of_type(:string)     }
  it { should have_db_column(:number).of_type(:integer)   }
  it { should have_db_column(:no_cache).of_type(:boolean) }
  it { should have_db_column(:hidden).of_type(:boolean)   }
end
