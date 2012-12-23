require 'spec_helper'

describe Qe::PageElement do
  it { should have_db_column(:qe_element_id).of_type(:integer) }
  it { should have_db_column(:qe_page_id).of_type(:integer)    }

  it { should belong_to :qe_page }
  it { should belong_to :qe_element }

  it { should have_db_column(:position).of_type(:integer) }
end
