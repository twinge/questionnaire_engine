FactoryGirl.define do
  factory :page, :class => Qe::Page do
    association :question_sheet
    label "label"
    number 1
  end
end

