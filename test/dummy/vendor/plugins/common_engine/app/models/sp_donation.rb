class SpDonation < ActiveRecord::Base
# This may be backed by Peoplesoft/Oracle in the future.  
# For now, it is backed by a table that is synchronized with Oracle
  def address
    street = [address1, address2, address3]
    street.reject!(&:blank?)
    "#{street.join('<br/>')}<br/>#{city}, #{state} #{zip}"
  end
  
  MEDIUMS = {
    'AE'  => 'American Express',
    'CCK' => 'Cashiers Check',
    'CSH' => 'Cash',
    'EFT' => 'Electronic Funds Transfer',
    'MC'  => 'MasterCard',
    'MO'  => 'Money Order',
    'PCK' => 'Personal Check',
    'VI'  => 'VISA',
    'WT'  => 'Wire Transfer',
    'CC'  => 'Other Credit Card',
    'DC'  => 'Diner\'s Club',
    'DS'  => 'Discover',
    'NCG' => 'Non-Cash Gift',
    'IGT' => 'Internal Gift Transfer'
  }
  # This may be backed by Peoplesoft/Oracle in the future.  
  # For now, it is backed by a table that is synchronized with Oracle
  def self.get_balance(designation_number)
    return 0 unless designation_number
    (SpDonation.sum(:amount, 
                    :conditions => ["designation_number = ?", designation_number]) || 0)
  end
  
  def self.get_balances(designation_numbers)
    return [] unless !designation_numbers.empty?
    sums = SpDonation.sum(:amount, 
      :conditions => ["designation_number in (?)", designation_numbers],
      :group => :designation_number)
    balances = Hash.new
    sums.each do |designation_number, amount|
      balances[designation_number] = amount
    end
    return balances
  end
  
  def self.update_from_peoplesoft
    last_date = SpDonation.maximum(:donation_date) || 2.years.ago
    rows = PsEmployee.connection.select_all("select * from hrsdon.ps_student_load_vw where donation_date > '#{last_date.to_s(:db)}'")
    rows.each do |row|
      row[:designation_number] = row.delete('designation')
      row[:donor_name] = row.delete('acct_name')
      row[:medium_type] = row.delete('don_medium_type')
      SpDonation.create(row)
    end
    rows.length
  end

	def	medium
		MEDIUMS[medium_type]
	end

end
