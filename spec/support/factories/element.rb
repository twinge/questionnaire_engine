FactoryGirl.define do
	factory :element, :class => Qe::Element do
		kind 'Qe::TextField'
		style 'qe/text_field'
		label 'text_field label'
		required false
	end
end
