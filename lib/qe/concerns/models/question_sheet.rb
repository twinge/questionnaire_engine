# QuestionSheet represents a particular form

require 'qe/model_extensions'
require 'qe/concerns/models/question'

module Qe::Concerns::Models::QuestionSheet
  extend ActiveSupport::Concern

  included do
    has_many :pages,      :class_name => Qe::Page, :dependent => :destroy, :order => 'number'
    has_many :elements,   :class_name => Qe::Element, :through => Qe::PageElement
    has_many :questions,  :class_name => Qe::Question
    has_many :answer_sheets, :class_name => Qe::AnswerSheet
    
    scope :active, where(:archived => false)
    scope :archived, where(:archived => true)
    
    validates_presence_of   :label
    validates_length_of     :label, :maximum => 60, :allow_nil => true  
    validates_uniqueness_of :label
    
    before_destroy :check_for_answers

    # TODO engineer the accessible attribute securities
    attr_accessible :label, :number, :archived, :fake_deleted

    # Creates a new QuestionSheet a Page already attached.
    def self.new_with_page
      question_sheet = self.new(:label => next_label)
      question_sheet.pages.build(:label => 'Page 1', :number => 1)
      question_sheet
    end

    # Clones QuestionSheet recursively (pages and elements).
    def duplicate
      new_sheet = Qe::QuestionSheet.new(self.attributes)
      new_sheet.label = self.label + ' - COPY'
      new_sheet.save(:validate => false)
      self.pages.each do |page|
        page.copy_to(new_sheet)
      end
      new_sheet
    end

    # Get all the elements of a QuesitonSheet
    def elements
      pages.collect(&:elements).flatten
    end

    private

    # Next unused label with "Untitled form" prefix
    def self.next_label
      Qe::ModelExtensions.next_label("Untitled form", untitled_labels)
    end

    # Returns a list of existing Untitled forms
    # (having a separate method makes it easy to mock in the spec)
    def self.untitled_labels
      Qe::QuestionSheet.find(:all, :conditions => %{label like 'Untitled form%'}).map {|s| s.label}
    end

    def check_for_answers
    end
  end
end
