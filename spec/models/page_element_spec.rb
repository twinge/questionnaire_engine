require 'spec_helper'

describe Qe::PageElement do 
  it { should belong_to :page }
  it { should belong_to :element }
end
