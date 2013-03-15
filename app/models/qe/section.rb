# == Schema Information
#
# Table name: qe_elements
#
#  id                 :integer          not null, primary key
#  question_grid_id   :integer
#  kind               :string(40)       not null
#  style              :string(40)
#  label              :string(255)
#  content            :text
#  required           :boolean
#  slug               :string(36)
#  position           :integer
#  object_name        :string(255)
#  attribute_name     :string(255)
#  source             :string(255)
#  value_xpath        :string(255)
#  text_path          :string(255)
#  cols               :string(255)
#  is_confidential    :boolean          default(FALSE)
#  total_cols         :string(255)
#  css_id             :string(255)
#  css_class          :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  question_sheet_id  :integer
#  conditional_id     :integer
#  tooltip            :text
#  hide_label         :boolean          default(FALSE)
#  hide_option_labels :boolean          default(FALSE)
#  max_length         :integer
#

module Qe
  class Section < Element
    module SectionModule
      extend ActiveSupport::Concern
      included do 
      end
    end

    include SectionModule
  end
end
