FactoryGirl.define do
  
  factory :question_sheet, class: Qe::QuestionSheet do
    label 'label'
  end

  factory :qs_with_page, parent: :question_sheet do
  	after :create do |qs|
  		page = FactoryGirl.create(:page, question_sheet: qs)
      element = FactoryGirl.create(:element)
      FactoryGirl.create(:page_element, element: element, page: page)
  	end
  end

end
