require 'spec_helper'

describe Qe::Element do
  
  it { Qe::Element.inheritance_column.should == 'kind' }

  it { should have_db_column(:kind) }
  it { should have_db_column(:style) }
  it { should have_db_column(:label) }
  it { should have_db_column(:content) }
  it { should have_db_column(:required) }
  it { should have_db_column(:slug) }
  it { should have_db_column(:position) }
  it { should have_db_column(:object_name) }
  it { should have_db_column(:source) }
  it { should have_db_column(:value_xpath) }
  it { should have_db_column(:text_path) }
  it { should have_db_column(:cols) }
  it { should have_db_column(:is_confidential) }
  it { should have_db_column(:total_cols) }
  it { should have_db_column(:css_id) }
  it { should have_db_column(:css_class) }
  it { should have_db_index :slug                                 }

  it { should have_many :page_elements }
  it { should have_many :pages }

  it { should validate_presence_of(:label) }
  it { should validate_presence_of(:style) }

  it { should ensure_inclusion_of(:kind).in_array(Qe::Element::KINDS) }
end
