# == Schema Information
#
# Table name: qe_email_templates
#
#  id         :integer          not null, primary key
#  name       :string(1000)     not null
#  content    :text
#  enabled    :boolean
#  subject    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module Qe
  class EmailTemplate < ActiveRecord::Base
    validates_presence_of :name

    attr_accessible :name, :content, :enabled, :subject
  end
end  
