FactoryGirl.define do
  factory :page_element, :class => Qe::PageElement do
    association :page
    association :element
  end
end

