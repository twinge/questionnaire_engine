module ModelExtensions

  # Helper for create a QuestionSheet or Page with the "next unused label"
  #  labels => an array of existing label strings
  #  prefix => the prefix that default pages/sheet have (ignores labels not matching this format)
  def next_label(prefix, labels)
    max = labels.inject(0) do |max, label|
      num = label[/^#{prefix} ([0-9]+)$/i, 1].to_i   # extract your digits
      num > max ? num : max
    end
  
    "#{prefix} #{max.next}"
  end
  
  module_function :next_label
  
end