# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def pretty_tag(txt)
    txt.to_s.gsub(/\s/, "_").gsub(/(?!-)\W/, "").downcase
  end

  def flatten_hash(hash = params, ancestor_names = [])
    flat_hash = {}
    hash.each do |k, v|
      names = Array.new(ancestor_names)
      names << k
      if v.is_a?(Hash)
        flat_hash.merge!(flatten_hash(v, names))
      else
        key = flat_hash_key(names)
        key += "[]" if v.is_a?(Array)
        flat_hash[key] = v
      end
    end
    
    flat_hash
  end

  def flat_hash_key(names)
    names = Array.new(names)
    name = names.shift.to_s.dup 
    names.each do |n|
      name << "[#{n}]"
    end
    name
  end
  
  def questionnaire_engine_stylesheets(options = {})
    output = []
    output << "qe/qe.screen"
    return output
  end

  def questionnaire_engine_javascripts(options = {})
    output = []
    output << "qe/jquery.validate.pack"
    output << "qe/jquery.metadata"
    output << "qe/jquery.tooltips.min"
    output << "qe/qe.common"
    if options[:area] == :public
      output << "qe/qe.public"
    else
      output << "qe/qe.admin"
      output << "qe/ckeditor/ckeditor"
    end
    output << "qe/jquery.scrollTo-min"
    output << {:cache => true} if options[:cache]
    return output 
  end

  def questionnaire_engine_includes(options = {})
    return "" if @qe_already_included
    @qe_already_included=true
    
    js = javascript_include_tag(*questionnaire_engine_javascripts(options))
    css = stylesheet_link_tag(*questionnaire_engine_stylesheets(options))
    "#{js}\n#{css}\n".html_safe
  end
  
  def calendar_date_select_tag(name, value = nil, options = {})
    options.merge!({'data-calendar' => true})
    text_field_tag(name, value, options )
  end
end
