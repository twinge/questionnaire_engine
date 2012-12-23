module Qe
  module Concerns
    module Models
      module Page

        extend ActiveSupport::Concern

        included do
          belongs_to :qe_question_sheet
        end

      end
    end
  end
end
