require 'spec_helper'

describe Qe::Admin::EmailTemplatesController do

	before(:each) do
		@template = Qe::EmailTemplate.create!(name: 'test')
	end
	
	it 'GET index' do
		get :index,
			use_route: 'qe'
	end
	it 'GET new' do
		get :new,
			use_route: 'qe'
	end
	it 'GET edit' do
		get :edit,
			use_route: 'qe',
			id: @template.id
	end
	it 'POST create' do
		name = "post_create"
		attributes = Qe::EmailTemplate.new(name: name).attributes
		
		post :create,
			use_route: 'qe',
			email_template: attributes

		created = Qe::EmailTemplate.find_by_name(name)
		created.should_not == nil
	end
	it 'PUT update' do
		name = 'put_update'
		@template.name = name

		put :update,
			use_route: 'qe',
			id: @template.id,
			email_template: @template.attributes

		@updated_template = Qe::EmailTemplate.find(@template.id)
		@updated_template.name.should == name
	end
	it 'DELETE destroy' do
		delete :destroy,
			use_route: 'qe',
			id: @template.id

		@remaining = Qe::EmailTemplate.all.count
		@remaining.should == 0
	end
end