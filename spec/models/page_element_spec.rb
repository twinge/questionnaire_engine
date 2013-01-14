require 'spec_helper'

describe Qe::PageElement do
  it { should have_db_column(:element_id).of_type(:integer) }
  it { should have_db_column(:page_id).of_type(:integer)    }
  it { should have_db_column(:position).of_type(:integer)   }

  it { should belong_to :page }
  it { should belong_to :element }
end
