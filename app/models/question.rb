# Question
# - An individual question element
# - children: TextField, ChoiceField, DateField, FileField

# :kind         - 'TextField', 'ChoiceField', 'DateField' for single table inheritance (STI)
# :label        - label for the question, such as "First name"
# :style        - essay|phone|email|numeric|currency|simple, selectbox|radio, checkbox, my|mdy
# :required     - is this question itself required or optional?
# :content      - choices (one per line) for choice field

class Question < Element
  include ActionController::RecordIdentifier # dom_id
  has_many :conditions, :class_name => "Condition", :foreign_key => "toggle_id", :dependent => :nullify
  has_many :dependents, :class_name => "Condition", :foreign_key => "trigger_id", :dependent => :nullify
  has_many :sheet_answers, :class_name => "Answer", :foreign_key => "question_id", :dependent => :destroy

  belongs_to :related_question_sheet, :class_name => "QuestionSheet", :foreign_key => "related_question_sheet_id"
  
  # validates_inclusion_of :required, :in => [false, true]
  
  validates_format_of :slug, :with => /^[a-z_][a-z0-9_]*$/, 
    :allow_nil => true, :if => Proc.new { |q| !q.slug.blank? },
    :message => 'may only contain lowercase letters, digits and underscores; and cannot begin with a digit.' # enforcing lowercase because javascript is case-sensitive
  validates_length_of :slug, :in => 4..36,
    :allow_nil => true, :if => Proc.new { |q| !q.slug.blank? }
  validates_uniqueness_of :slug,
    :allow_nil => true, :if => Proc.new { |q| !q.slug.blank? },
    :message => 'must be unique.'
    
  # a question has one response per AnswerSheet (that is, an instance of a user filling out the question)
  # generally the response is a single answer
  # however, "Choose Many" (checkbox) questions have multiple answers in a single response
  
  attr_accessor :answers
  
  # @answers = nil            # one or more answers in response to this question
  # @mark_for_destroy = nil   # when something is unchecked, there are less answers to the question than before
  
  
  # a question is disabled if there is a condition, and that condition evaluates to false
  # could set multiple conditions to influence this question, in which case all must be met
  # def active?
  #   # find first condition that doesn't pass (nil if all pass)
  #   self.conditions.find(:all).find { |c| !c.evaluate? }.nil?  # true if all pass
  # end
  
  # def conditions_attributes=(new_conditions)
  #   conditions.collect(&:destroy)
  #   conditions.reload
  #   (0..(new_conditions.length - 1)).each do |i|
  #     i = i.to_s
  #     expression = new_conditions[i]["expression"]
  #     trigger_id = new_conditions[i]["trigger_id"].to_i
  #     unless expression.blank? || !page.questions.collect(&:id).include?(trigger_id) || conditions.collect(&:trigger_id).include?(trigger_id)
  #       conditions.create(:question_sheet_id => question_sheet_id, :trigger_id => trigger_id, 
  #                         :expression => expression, :toggle_page_id => page_id,
  #                         :toggle_id => self.id) 
  #     end
  #   end
  # end
  
  # element view provides the element label with required indicator
  def default_label?
    true
  end
  
  # css class names for javascript-based validation
  def validation_class(answer_sheet)
    if self.required?(answer_sheet)
      ' required ' 
    else
      ''
    end
  end
  
  # just in case something slips through client-side validation?
  # def valid_response?
  #   if self.required? && !self.has_response? then
  #     false
  #   else
  #     # other validations
  #     true
  #   end
  # end
  
  # just in case something slips through client-side validation?
  # def valid_response_for_answer_sheet?(answers)
  #    return true if !self.required? 
  #    answer  = answers.detect {|a| a.question_id == self.id}
  #    return answer && answer.value.present?
  #    # raise answer.inspect 
  #  end
  
  # shortcut to return first answer
  def response(app)
    responses(app).first.to_s
  end
  
  def display_response(app)
    r = responses(app)
    if r.blank?
      "No Answer"
    else
      r.join(", ")
    end
  end
  
  def responses(app)
    return [] unless app
    # try to find answer from external object
    if !object_name.blank? and !attribute_name.blank?
      if eval("app." + object_name + ".nil?") or eval("app." + object_name + "." + attribute_name + ".nil?")
        []
      else
        [eval("app." + object_name + "." + attribute_name)] 
      end
    else
      app.answers_by_question[id] || []
      # Answer.where(:answer_sheet_id => app.id, :question_id => self.id)
    end
  end
  
  # set answers from posted response
  def set_response(values, app)
    values = Array.wrap(values)
    if !object_name.blank? and !attribute_name.blank?
      # if eval("app." + object_name).present?
      object = eval("app." + object_name)
      unless object.present?
        if object_name.include?('.')
          objects = object_name.split('.')
          object = eval("app." + objects[0..-2].join('.') + ".create_" + objects.last)
          eval("app." + objects[0..-2].join('.')).reload
        end
      end
      unless responses(app) == values
        value = ActiveRecord::Base.connection.quote_string(values.first)
        if self.is_a?(DateField) && value.present?
          begin
            value = Date.strptime(value, (I18n.t 'date.formats.default'))
          rescue
            raise "invalid date - " + value.inspect
          end
        end
        object.update_attribute(attribute_name, value) 
      end
      # else
      #   raise object_name.inspect + ' == ' + attribute_name.inspect
      # end
    else
      @answers ||= []
      @mark_for_destroy ||= []
      # go through existing answers (in reverse order, as we delete)
      (@answers.length - 1).downto(0) do |index|
        # reject: skip over responses that are unchanged
        unless values.reject! {|value| value == @answers[index]}
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
  end
  
  def save_file(answer_sheet, file)
    @answers.collect(&:destroy) if @answers
    answer = Answer.create!(:question_id => self.id, :answer_sheet_id => answer_sheet.id, :attachment => file)
  end
  
  # save this question's @answers to database
  def save_response(answer_sheet)
    unless @answers.nil?
      for answer in @answers
        if answer.is_a?(Answer)
          answer.answer_sheet_id = answer_sheet.id
          answer.save!
        end
      end
    end
    
    # remove others
    unless @mark_for_destroy.nil?
      for answer in @mark_for_destroy
        answer.destroy
      end
      @mark_for_destroy.clear
    end
  rescue TypeError
    raise answer.inspect
  end
  
  # has any sort of non-empty response?
  def has_response?(answer_sheet = nil)
    if answer_sheet.present?
      answers = responses(answer_sheet)
    else
      answers = Answer.where(:question_id => self.id)
    end
    return false if answers.length == 0
    answers.each do |answer|   # loop through Answers
      value = answer.is_a?(Answer) ? answer.value : answer
      return true if value === false || value.present? 
    end
    return false
  end
  
  def required?(answer_sheet = nil)
    super() || (!answer_sheet.nil? && !choice_field.nil? && choice_field.has_answer?(true, answer_sheet))
  end

end
