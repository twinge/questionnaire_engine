# A presenter is a class representation of a view, which consolidates data from multiple models
# Pages editing can be initiated from 3 different controllers, AnswerSheets for the initial load, 
#   AnswerPages to AJAX load in another page, and (in BOAT) the ApplicationsController for multiple sheets.
# Rather than duplicate code from controller to controller, each place can simply reference this Presenter.

# We always need data to render the current page for editing. 
# On the initial load, we need data for the page list (sidebar).
# On later page loads, we need to determine the "next page" which basically requires the page list again.
require_dependency 'presenter'
class AnswerPagesPresenter < Presenter
  unloadable
  
  #attr_reader :answer_sheet, :question_sheet

  attr_accessor :active_answer_sheet, :page_links, :active_page
  
  def initialize(controller, answer_sheets, custom_pages = nil)
    super(controller)
    if answer_sheets.kind_of?(AnswerSheet) 
      @answer_sheets = [answer_sheets]  # stuff single AnswerSheet into an array
    else
      @answer_sheets = answer_sheets
    end
    @active_answer_sheet = @answer_sheets.first
    
    @page_links = page_list(@answer_sheets, custom_pages)
  end
    
  def questions_for_page(page_id=:first)
    @active_page = page_id == :first ? pages.first : pages.detect {|p| p.id == page_id.to_i}
    @active_page ||= @active_answer_sheet.pages.visible.find(page_id)
    QuestionSet.new(@active_page ? @active_page.elements : [], @active_answer_sheet)
  end
    
  def all_questions_for_page(page_id=:first)
    @active_page = page_id == :first ? pages.first : pages.detect {|p| p.id == page_id.to_i}
    @active_page ||= @active_answer_sheet.pages.visible.find(page_id)
    QuestionSet.new(@active_page ? @active_page.all_elements : [], @active_answer_sheet)
  end
  
  # title
  def sheet_title
    @active_answer_sheet.question_sheet.label
  end
  
  def active_page
    link = new_page_link(@active_answer_sheet, @active_page)
    link.save_path = answer_sheet_page_path(@active_answer_sheet, @active_page)
    link
  end
  
  def next_page
    active_page_dom_id = active_page.dom_id
    
    this_page = @page_links.find {|p| p.dom_id == active_page_dom_id}
    @page_links.at( @page_links.index(this_page) + 1 ) unless this_page.nil?
  end
  
  def reference?
    if @active_answer_sheet.respond_to?(:apply_sheet)
      @active_answer_sheet.apply_sheet.sleeve_sheet.assign_to == 'reference'
    else
      false
    end
  end
  
  protected
  
  # for pages_list sidebar
  def page_list(answer_sheets, custom_pages = nil)
    page_list = []
    answer_sheets.each do |answer_sheet|
      pages(answer_sheet).each do |page|
        page_list << new_page_link(answer_sheet, page)
      end
    end
    page_list = page_list + custom_pages unless custom_pages.nil?
    page_list
  end
  
  def pages(answer_sheet = active_answer_sheet)
    unless @pages && @pages[answer_sheet.id]
      @pages ||= {}
      @pages[answer_sheet.id] = []
      answer_sheet.question_sheets.each do |qs|
        qs.pages.visible.each do |page|
          @pages[answer_sheet.id] << page
        end
      end
    end
    @pages[answer_sheet.id]
  end

  def new_page_link(answer_sheet, page)
    PageLink.new(page.label, edit_answer_sheet_page_path(answer_sheet, page), dom_page(answer_sheet, page))
  end
  
  # page is identified by answer sheet, so can have multiple sheets loaded at once
  def dom_page(answer_sheet, page)
    dom = "#{dom_id(answer_sheet)}-#{dom_id(page)}"
    dom += "-no_cache" if page.no_cache
    dom
  end
  
end