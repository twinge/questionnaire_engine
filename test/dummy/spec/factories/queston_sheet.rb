FactoryGirl.define do
  factory :question_sheet, :class => Qe::QuestionSheet do
    label "label"
  end

  factory :qs_with_page, parent: :question_sheet do
  	after :create do |qs|
  		FactoryGirl.create(:page, question_sheet: qs)
  		# FactoryGirl.create(:element, question_sheet: qs)
  	end
  end
end
