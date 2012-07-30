
@random_number = rand

FactoryGirl.define do
  factory :page, :class => Qe::Page do
    association :question_sheet
    label @random_number.to_s
    number 1
  end
end

