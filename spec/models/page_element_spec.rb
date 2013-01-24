require 'spec_helper'

describe Qe::PageElement do
  it { should have_db_column(:element_id) }
  it { should have_db_column(:page_id) }
  it { should have_db_column(:position) }

  it { should belong_to :page }
  it { should belong_to :element }
end
