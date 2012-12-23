module Qe
  module Concerns
    module Models
      module QuestionSheet

        extend ActiveSupport::Concern

        included do
          has_many :qe_pages
          has_many :qe_conditions
        end

      end
    end
  end
end
