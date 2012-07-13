class Address < ActiveRecord::Base
  unloadable
  
  set_table_name				"ministry_newaddress"
	set_primary_key 			"addressID"
	
	validates_presence_of :addressType
	
	belongs_to :person, :foreign_key => "fk_PersonID"
	
	before_save :stamp
	
  #set dateChanged and changedBy
  def stamp
    self.dateChanged = Time.now
    self.changedBy = ApplicationController.application_name
  end
	
	def display_html
	  ret_val = address1 || ''
		ret_val += '<br/>'+address2 unless address2.nil? || address2.empty? 
		ret_val += '<br/>' unless ret_val.empty?
		ret_val += city+', ' unless city.nil? || city.empty? 
		ret_val += state + ' ' unless state.nil?
		ret_val += zip unless zip.nil?
		ret_val += '<br/>'+country+',' unless country.nil? || country.empty? || country == 'USA'
		return ret_val
	end
	
	def address
	 	ret_val = address1 || ''
		ret_val += ', ' + address2 unless address2.nil? || address2.empty? 
		ret_val += ', ' unless ret_val.empty?
		ret_val += city + ', ' unless city.nil? || city.empty? 
		ret_val += state + ' ' unless state.nil?
		ret_val += zip unless zip.nil?
		ret_val += ', ' + country unless country.nil? || country.empty? || country == 'USA'
		return ret_val
	end
	
	def phone_number
    phone = (self.homePhone && !self.homePhone.empty?) ? self.homePhone : self.cellPhone
    phone = (phone && !phone.empty?) ? phone : self.workPhone
    phone
	end
end
