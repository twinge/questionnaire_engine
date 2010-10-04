require 'net/http'
begin
  require 'xml/libxml'
rescue LoadError
  require 'rexml/document'
end

# ChoiceField
# - a question that allows the selection of one or more choices

class ChoiceField < Question
  # Returns choices stored one per line in content field
	def choices
    retVal = Array.new 
    if ['yes-no', 'acceptance'].include?(self.style)
      return [["Yes",1],["No",0]]
    elsif !source.blank?
  	  begin
        doc = XML::Document.file(source)
        options = doc.find(text_xpath).collect { |n| n.content }
        values = doc.find(value_xpath).collect { |n| n.content }
        retVal = [options, values].transpose
      rescue NameError
        doc = REXML::Document.new Net::HTTP.get_response(URI.parse(source)).body
        retVal = [ doc.elements.collect(text_xpath){|c|c.text}, doc.elements.collect(value_xpath){|c|c.text} ].transpose.sort
      end
    elsif !content.nil?
      content.split("\n").each do |opt|
        pair = opt.strip.split(";").reverse!
        pair[1] ||= pair[0]
        retVal << pair
      end
    end
    return retVal
  end
	
	def has_answer?(choice, app=nil)
    # HACK: Crazy hack to support legacy field types where choices may be int or tinyint 
    r = self.responses(app) 
	  if @answers.nil? || @answers.empty?   # external data source?
      return true if r[0] == is_true(choice) || r[0] == is_false(choice) || r[0] == choice.to_s || r[0] == choice.to_i
    else 
  	  r.each do |answer|   # loop through Answers
        if answer.to_s == choice.to_s   # true if this answer matches the choice passed
          return true
        end
      end
    end
    false
	end
	
	# which view to render this element?
  def ptemplate
    if self.style == 'checkbox'
      'checkbox_field'
    elsif self.style == 'drop-down'
      'drop_down_field'
    elsif self.style == 'radio'
      'radio_button_field'
    elsif self.style == 'yes-no'
      'yes_no'
    elsif self.style == 'rating'
      'rating'
    elsif self.style == 'acceptance'
      'acceptance'
    end
	end
	
	# element view provides the element label?
  def default_label?
    if self.style == 'acceptance'
      false   # template provides its own label
    else
      true
    end
  end
	
	# css class names for javascript-based validation
  def validation_class
    if self.required?
      if self.style == 'drop-down'
        'validate-selection' 
      elsif self.style == 'rating'
        'validate-rating'
      elsif self.style == 'acceptance'
        'required'
      else
        'validate-one-required'
      end
    else
      ''
    end
  end
  
  def display_response(app=nil)
    r = responses(app)

    if r.blank?
      "No Answer" 
    elsif self.style == 'yes-no'
      ans = r.first
      if ans.class == Answer
        is_true(ans.value) ? "Yes" : "No"
      else
        is_true(ans) ? "Yes" : "No"
      end
    elsif self.style == 'acceptance'
      "Accepted"  # if not blank, it's accepted
    else
      r.join(", ")
    end
  end

  protected
  def is_true(val)
    [1,'1',true,'true','Yes','yes'].include?(val) # note: true = anything but false | nil
  end

  def is_false(val)
    # returns false if false (a bit odd)
    ![0,'0',false,'false','No','no'].include?(val)
  end


end