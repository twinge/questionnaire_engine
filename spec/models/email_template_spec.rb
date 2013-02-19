require 'spec_helper'

describe Qe::EmailTemplate do 
  it { should have_db_column :name }
end