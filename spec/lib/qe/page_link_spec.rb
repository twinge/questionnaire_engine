require 'spec_helper'

describe Qe::PageLink do 

  let(:subject) { Qe::PageLink.new('arg_dom_id', 'arg_load_path', 'arg_page', 'arg_save_path') }

  it { should respond_to :dom_id= }
  it { should respond_to :load_path= }
  it { should respond_to :page= }
  it { should respond_to :save_path= }
end