# Question
# - An individual question element
# - children: TextField, ChoiceField, DateField, FileField

# :kind         - 'TextField', 'ChoiceField', 'DateField' for single table inheritance (STI)
# :label        - label for the question, such as "First name"
# :style        - essay|phone|email|numeric|currency|simple, selectbox|radio, checkbox, my|mdy
# :required     - is this question itself required or optional?
# :content      - choices (one per line) for choice field

class Question < Element
  has_many :conditions, :class_name => "Condition", :foreign_key => "toggle_id", :dependent => :nullify
  has_many :dependents, :class_name => "Condition", :foreign_key => "trigger_id", :dependent => :nullify
  
  validates_inclusion_of :required, :in => [false, true]
  
  validates_format_of :slug, :with => /^[a-z_][a-z0-9_]*$/, 
    :allow_nil => true, :if => Proc.new { |q| !q.slug.blank? },
    :message => 'may only contain lowercase letters, digits and underscores; and cannot begin with a digit.' # enforcing lowercase because javascript is case-sensitive
  validates_length_of :slug, :in => 4..36,
    :allow_nil => true, :if => Proc.new { |q| !q.slug.blank? }
  validates_uniqueness_of :slug, :scope => 'question_sheet_id',
    :allow_nil => true, :if => Proc.new { |q| !q.slug.blank? },
    :message => 'must be unique across this form.'
    
  # a question has one response per AnswerSheet (that is, an instance of a user filling out the question)
  # generally the response is a single answer
  # however, "Choose Many" (checkbox) questions have multiple answers in a single response
  
  attr_accessor :answers
  
  @answers = nil            # one or more answers in response to this question
  @mark_for_destroy = nil   # when something is unchecked, there are less answers to the question than before
  
  
  # a question is disabled if there is a condition, and that condition evaluates to false
  # could set multiple conditions to influence this question, in which case all must be met
  def active?
    # find first condition that doesn't pass (nil if all pass)
    self.conditions.find(:all).find { |c| !c.evaluate? }.nil?  # true if all pass
  end
  
  # element view provides the element label with required indicator
  def default_label?
    true
  end
  
  # the value of this question triggers the enabled/disabled state of other pages/elements with javascript
  def condition_handler_js
    # what is our current value?
    js = <<-JS
      response = $F('#{dom_id(self)}')
    JS
    
    # use response to trigger pages and elements that are dependent on this question
    self.dependents.find(:all) { |d| js = js + d.trigger_js }
    js
  end
  
  # css class names for javascript-based validation
  def validation_class
    if self.required?
      'required' 
    else
      ''
    end
  end
  
  # just in case something slips through client-side validation?
  def valid_response?
    if self.required? && !self.has_response? then
      false
    else
      # other validations
      true
    end
  end

  # shortcut to return first answer
  def response(app=nil)
    get_response(app)
  end
  
  def display_response(app=nil)
    r = get_response(app)
    if r.blank?
      "No Answer"
    else
      r.join(", ")
    end
  end
  
  def get_response(app=nil)
    if @answers.nil? || @answers.empty?
      # try to find answer from external object
      if !app.nil? and !object_name.blank? and !attribute_name.blank?
        if eval("app." + object_name + ".nil?") or eval("app." + object_name + "." + attribute_name + ".nil?")
          []
        else
          [eval("app." + object_name + "." + attribute_name)] 
        end
      else
        ""
      end
    else
      @answers
    end
  end
  
  # set answers from posted response
  def response=(values)
    @answers ||= []
    @mark_for_destroy ||= []
          
    # go through existing answers (in reverse order, as we delete)
    (@answers.length - 1).downto(0) do |index|
      # reject: skip over responses that are unchanged
      unless values.reject! {|value| value == @answers[index].value}
        # remove any answers that don't match the posted values
        @mark_for_destroy << @answers[index]   # destroy from database later 
        @answers.delete_at(index)
      end
    end
    
    # insert any new answers
    for value in values
      if @mark_for_destroy.empty?
        answer = Answer.new(:question_id => self.id)
      else
        # re-use marked answers (an update vs. a delete+insert)
        answer = @mark_for_destroy.pop
      end
      answer.set(value)
      @answers << answer
    end
  end
  
  # save this question's @answers to database
  def save_response(answer_sheet)
    unless @answers.nil?
      for answer in @answers
        answer.answer_sheet_id = answer_sheet.id
        answer.save
      end
    end
    
    # remove others
    unless @mark_for_destroy.nil?
      for answer in @mark_for_destroy
        answer.destroy
      end
      @mark_for_destroy.clear
    end
  end
  
  # has any sort of non-empty response?
  def has_response?
    if @answers.nil? then
      false
    else
      rc = false
      @answers.each do |answer|   # loop through Answers
        if !answer.value.blank? then   # any response is good enough
          rc = true
          break
        end
      end
      rc
    end
  end

end
