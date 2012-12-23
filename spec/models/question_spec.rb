require 'spec_helper'

describe Qe::Question do
  it { should have_db_column :label }
  it { should have_db_column :archived }
end
