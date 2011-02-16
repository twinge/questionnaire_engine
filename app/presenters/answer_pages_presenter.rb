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
  
  attr_accessor :active_answer_sheet, :page_links, :active_page, :pages
  
  def initialize(controller, answer_sheets, a = nil, custom_pages = nil)
    super(controller)
    @answer_sheets = Array.wrap(answer_sheets)
    @active_answer_sheet = @answer_sheets.first
    initialize_pages(@active_answer_sheet)
    
    @page_links = page_list(@answer_sheets, a, custom_pages)
  end
    
  def questions_for_page(page_id=:first)
    @active_page = page_id == :first ? pages.first : pages.detect {|p| p.id == page_id.to_i}
    @active_page ||= @active_answer_sheet.pages.visible.includes(:elements).find(page_id)
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
    return unless @active_page
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
  
  def initialize_pages(answer_sheet)
    @pages = []
    answer_sheet.question_sheets.each do |qs|
      qs.pages.visible.each do |page|
        @pages << page
      end
    end
  end
  
  def started?
    active_answer_sheet.question_sheets.each do |qs|
      qs.pages.visible.each do |page|
        return true if page.started?(active_answer_sheet)
      end
    end
  end

  def new_page_link(answer_sheet, page, a = nil)
    PageLink.new(page.label, edit_answer_sheet_page_path(answer_sheet, page, :a => a), dom_page(answer_sheet, page), page) if page
  end
  
  protected
  
  # for pages_list sidebar
  def page_list(answer_sheets, a = nil, custom_pages = nil)
    page_list = []
    answer_sheets.each do |answer_sheet|
      pages.each do |page|
        page_list << new_page_link(answer_sheet, page, a)
      end
    end
    page_list = page_list + custom_pages unless custom_pages.nil?
    page_list
  end
  
  # page is identified by answer sheet, so can have multiple sheets loaded at once
  def dom_page(answer_sheet, page)
    dom = "#{dom_id(answer_sheet)}-#{dom_id(page)}"
    dom += "-no_cache" if page.no_cache
    dom
  end
  
end