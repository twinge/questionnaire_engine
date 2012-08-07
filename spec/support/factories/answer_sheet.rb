FactoryGirl.define do
	factory :answer_sheet do
		association :question_sheet
	end
end
