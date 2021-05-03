# frozen_string_literal: true

require "active_support/concern"

module MeetingsRegistrationSerializerExtend
  extend ActiveSupport::Concern

  included do

    # Serializes a registration
    def serialize
      {
        id: resource.id,
        code: resource.code,
        user: {
          name: resource.user.name,
          # email: resource.user.email,
          user_group: resource.user_group&.name || ""
        },
        registration_form_answers: serialize_answers
      }
    end

  end
end

Decidim::Meetings::RegistrationSerializer.send(:include, MeetingsRegistrationSerializerExtend)
