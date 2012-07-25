FactoryGirl.define do
	factory :element, :class => Qe::Element do
		kind "Qe::TextField"
		style "qe/text_field"
		required false
	end
end
