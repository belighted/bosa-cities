# frozen_string_literal: true

require "active_support/concern"

module AttachmentMethodsExtend
  extend ActiveSupport::Concern

  included do
    include Decidim::Initiatives::CurrentLocale

    private

    def build_attachment
      @attachment = Decidim::Attachment.new(
        title: {current_locale => @form.attachment.title},
        file: @form.attachment.file,
        attached_to: @attached_to
      )
    end

  end
end

Decidim::Initiatives::AttachmentMethods.send(:include, AttachmentMethodsExtend)
