FactoryGirl.define do
  factory :question, class: Qe::Question do
    kind 'Qe::TextField'
    required false
    question_sheet_id 1
  end
end
