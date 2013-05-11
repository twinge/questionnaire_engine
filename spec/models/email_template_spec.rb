require 'spec_helper'

describe Qe::EmailTemplate do 
  it { should validate_presence_of :name }
end
