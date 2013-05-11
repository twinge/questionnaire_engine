require 'spec_helper'

describe Qe::Element do 
  it { should belong_to :question_sheet }
  it { should belong_to :question_grids }
  it { should belong_to :choice_fields }
  it { should have_many :page_elements }
  it { should have_many :pages }
  it { should ensure_inclusion_of(:kind).in_array(Qe::Element::KINDS)}
  
  xit { should validate_presence_of :label }
  xit 'validate max label length = 255'
end
