FactoryGirl.define do
	factory :answer_sheet_master, :class => Qe::AnswerSheet do
		association :question_sheet, :factory => :question_sheet
	end
end
