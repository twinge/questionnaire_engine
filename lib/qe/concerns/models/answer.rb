module Qe
  module Concerns
    module Models
      module Answer

        extend ActiveSupport::Concern

        included do
          belongs_to :qe_answer_sheet
        end

      end
    end
  end
end
