module Qe
  module Concerns
    module Models
      module PageElement

        extend ActiveSupport::Concern

        included do
          belongs_to :qe_page
          belongs_to :qe_element
        end

      end
    end
  end
end

