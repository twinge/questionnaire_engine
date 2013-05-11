FactoryGirl.define do
  factory :question, class: Qe::Question do
    kind 'Qe::TextField'
    required false
  end
end
