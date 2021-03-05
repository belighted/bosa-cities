# frozen_string_literal: true

require "active_support/concern"

module SendInitiativeToTechnicalValidationExtend
  extend ActiveSupport::Concern

  included do

    def call
      @initiative = Decidim.traceability.perform_action!(
        :send_to_technical_validation,
        initiative,
        current_user
      ) do
        initiative.validating!
        initiative
      end

      notify_admins
      notify_author

      broadcast(:ok, initiative)
    end

    private

    def notify_author
      Decidim::EventsManager.publish(
        event: "decidim.events.initiatives.initiative_sent_to_technical_validation",
        event_class: Decidim::Initiatives::InitiativeSentToTechnicalValidationEvent,
        resource: initiative,
        affected_users: [initiative.author],
        force_send: true
      )
    end

  end
end

Decidim::Initiatives::Admin::SendInitiativeToTechnicalValidation.send(:include, SendInitiativeToTechnicalValidationExtend)
