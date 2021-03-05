# frozen-string_literal: true

module Decidim
  module Initiatives
    class InitiativeSentToTechnicalValidationEvent < Decidim::Events::SimpleEvent
      include Decidim::Events::AuthorEvent

    end
  end
end
