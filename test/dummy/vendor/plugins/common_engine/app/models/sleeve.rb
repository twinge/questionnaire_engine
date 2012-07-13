# represents an "Application" which holds several QuestionSheets
# think "manilla folder"
class Sleeve < ActiveRecord::Base
  unloadable
  set_table_name "#{TABLE_NAME_PREFIX}#{self.table_name}"
  
  has_many :sleeve_sheets
  has_many :applies
  
  validates_presence_of :title
  validates_length_of :title, :maximum => 60, :allow_nil => true
  validates_format_of :slug, :with => /^[a-z_][a-z0-9_]*$/, 
    :allow_nil => true, :if => Proc.new { |q| !q.slug.blank? },
    :message => 'may only contain lowercase letters, digits and underscores; and cannot begin with a digit.' # enforcing lowercase because javascript is case-sensitive
  validates_length_of :slug, :in => 4..36,
    :allow_nil => true, :if => Proc.new { |q| !q.slug.blank? }
  validates_uniqueness_of :slug, 
    :allow_nil => true, :if => Proc.new { |q| !q.slug.blank? },
    :message => 'must be unique.'
  
  
  def applicant_sheets
    app_sheets = Array.new()
    sleeve_sheets.each do |s|
      app_sheets << s if s.assign_to == 'applicant'
    end
    app_sheets
  end
  
  def reference_sheets
    ref_sheets = Array.new()
    sleeve_sheets.each do |s|
      ref_sheets << s if s.assign_to == 'reference'
    end
    ref_sheets
  end
  
end
