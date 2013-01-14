module Qe
  mattr_accessor :table_name_prefix
  self.table_name_prefix ||= 'qe_'
end
