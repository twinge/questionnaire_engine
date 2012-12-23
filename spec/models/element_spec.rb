require 'spec_helper'


describe Qe::Element do
  it { should have_many :qe_page_elements }
  it { should have_many :qe_pages }

  it { should have_db_column(:kind).of_type(:string)              }
  it { should have_db_column(:style).of_type(:string)             }
  it { should have_db_column(:label).of_type(:string)             }
  it { should have_db_column(:content).of_type(:text)             }
  it { should have_db_column(:required).of_type(:boolean)         }
  it { should have_db_column(:slug).of_type(:string)              }
  it { should have_db_column(:position).of_type(:integer)         }
  it { should have_db_column(:object_name).of_type(:string)       }
  it { should have_db_column(:source).of_type(:string)            }
  it { should have_db_column(:value_xpath).of_type(:string)       }
  it { should have_db_column(:text_path).of_type(:string)         }
  it { should have_db_column(:cols).of_type(:string)              }
  it { should have_db_column(:is_confidential).of_type(:boolean)  }
  it { should have_db_column(:total_cols).of_type(:string)        }
  it { should have_db_column(:css_id).of_type(:string)            }
  it { should have_db_column(:css_class).of_type(:string)         }

  it { should have_db_index :slug }
end
