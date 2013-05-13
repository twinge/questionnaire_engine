FactoryGirl.define do
	
  factory :answer, class: Qe::Answer do
		association :answer_sheet
	end

end
