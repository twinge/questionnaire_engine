class Qe::Element < ActiveRecord::Base
  self.inheritance_column = 'fake'
end

class ApplyQeNamespaceToPrElements < ActiveRecord::Migration
  def up
		Qe::Element.all.each do |e|
			# In order to use the Qe namespace conventions
			# QuestionGrid => Qe::QuestionGrid 
			# question_grid => qe/question_grid
			kind_new = 'Qe::' + e.kind
			style_new = 'qe/' + e.style
      Qe::Element.connection.update("UPDATE #{Qe::Element.table_name} set kind = '#{kind_new}', style = '#{style_new}' where id = #{e.id}")
		end
  end

  def down
  	# reverse the namespace conventions
  	Qe::Element.all.each do |e|
  		kind_old = e.kind.split(/Qe::/).second
			style_old = e.style.split(/qe\//).second
      Qe::Element.connection.update("UPDATE #{Qe::Element.table_name} set kind = '#{kind_old}', style = '#{style_old}' where id = #{e.id}")
  	end
  end
end

