# frozen_string_literal: true

require "active_support/concern"

module MessageExtend
  extend ActiveSupport::Concern

  included do
    clear_validators!
    validates :sender, :body, presence: true

    validate :sender_is_participant
  end
end

Decidim::Messaging::Message.send(:include, MessageExtend)
