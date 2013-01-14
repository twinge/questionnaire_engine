require 'spec_helper'

describe Qe::Answer do
  it { should have_db_column :answer_sheet_id }
  it { should have_db_column(:value).of_type(:text)          }
  it { should have_db_column(:short_value).of_type(:string)  }
  it { should have_db_column(:size).of_type(:integer)        }
  it { should have_db_column(:content_type).of_type(:string) }
  it { should have_db_column(:filename).of_type(:string)     }
  it { should have_db_column(:height).of_type(:integer)      }
  it { should have_db_column(:width).of_type(:integer)       }
  it { should have_db_column(:parent_id).of_type(:integer)   }
  it { should have_db_column(:thumbnail).of_type(:string)    }
  it { should have_db_index :short_value }
  
  it { should belong_to :answer_sheet }
end
