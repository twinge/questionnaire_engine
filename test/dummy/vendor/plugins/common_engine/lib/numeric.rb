class Numeric
  def dollars
    val = sprintf("$%.0f",self)
  end
  
  def cents
    (self*100).round % 100
  end
  
  def dollars_and_cents
    dollars + '.' + cents.to_s
  end
end