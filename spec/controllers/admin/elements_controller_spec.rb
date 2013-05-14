require 'spec_helper'

describe Qe::Admin::ElementsController do
  
  before(:each) do
    @question_sheet = FactoryGirl.create(:qs_with_page)
    @page = @question_sheet.pages.first

    @text_field = @page.elements.first
    @text_field.kind.should == 'Qe::TextField'
  end

  it "GET new" do
    xhr :get, :new,
      use_route: 'qe',
      page_id: @page.id,
      question_sheet_id: @question_sheet.id, 
      element_type: 'TextField'
  end

  it "POST create" do
    xhr :post, :create,
      use_route: 'qe', 
      page_id: @page.id,
      element_type: 'Section',
      :element => {kind: 'Qe::Section', style: 'qe/section'}
    
    @section = Qe::Element.find_by_kind('Qe::Section')
    @section.should_not == nil

    @page.elements.count.should == 2
  end

  it "GET edit" do
    xhr :get, :edit, 
      use_route: 'qe',
      page_id: @page.id, 
      id: @page.elements.first.id
  end

  it 'PUT update' do
    new_label = 'new and revised label'

    # update the text field
    xhr :put, :update,
      use_route: 'qe',
      page_id: @page.id,
      id: @text_field.id,
      element: {label: new_label}

    # retreave and confirm the same object by id
    @updated_text_field = Qe::Element.all.first
    @updated_text_field.id.should == @text_field.id
    
    # confirm set label value == retreaved label value
    @updated_text_field.label = new_label
  end

  it 'POST duplicate' do
    xhr :post, :duplicate,
      use_route: 'qe',
      page_id: @page.id,
      id: @text_field.id

    @page.elements.count.should == 2
  end

  describe 'POST use_existing' do
    it 'add duplicate element, fail' do
      xhr :post, :use_existing,
        use_route: 'qe',
        page_id: @page.id,
        id: @text_field.id
      @page.elements.count.should == 1
    end
    it 'add different element, succeed' do
      @new_element = @page.elements.create!(kind: 'Qe::Section', style: 'qe/section', label: 'some string here')

      xhr :post, :use_existing,
        use_route: 'qe',
        page_id: @page.id,
        id: @new_element.id
      @page.elements.count.should == 2
    end
  end

  it "PUT destroy" do
    xhr :delete, :destroy,
      use_route: 'qe',
      page_id: @page.id,
      id: @text_field.id,
      element_id: @text_field.id

    @page.elements.count.should == 0
  end

end