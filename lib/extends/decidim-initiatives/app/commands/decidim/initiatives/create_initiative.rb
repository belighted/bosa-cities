# frozen_string_literal: true

require "active_support/concern"

module CreateInitiativeExtend
  extend ActiveSupport::Concern

  included do

    private

    def create_initiative
      initiative = build_initiative
      return initiative unless initiative.valid?

      initiative.transaction do
        initiative.save!
        @attached_to = initiative
        create_attachment if process_attachments?
        create_components_for(initiative)
        send_notification(initiative)
        notify_admins(initiative)
        add_author_as_follower(initiative)
        add_author_as_committee_member(initiative)
      end

      initiative
    end

    def notify_admins(initiative)
      Decidim::EventsManager.publish(
        event: "decidim.events.initiatives.admin.initiative_created",
        event_class: Decidim::Initiatives::Admin::InitiativeCreatedEvent,
        resource: initiative,
        affected_users: current_user.organization.admins.all,
        force_send: true
      )
    end

  end
end

Decidim::Initiatives::CreateInitiative.send(:include, CreateInitiativeExtend)
