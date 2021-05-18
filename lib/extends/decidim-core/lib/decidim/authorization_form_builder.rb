# frozen_string_literal: true

require "active_support/concern"

module AuthorizationFormBuilderExtend
  extend ActiveSupport::Concern

  included do

    def all_fields
      fields = []
      public_attributes.map do |name, type|
        template = @template.content_tag(:div, input_field(name, type), class: "field")
        if name.to_sym == :document_number
          help_text = I18n.t("decidim.authorization_form.document_number_help_text")
          template += content_tag(:p, help_text, class: "help-text") if help_text.present?
        end
        fields << template
      end

      safe_join(fields)
    end

    private

    def input_field(name, type)
      return hidden_field(name) if name.to_s == "handler_name"
      return scopes_selector if name.to_s == "scope_id"

      case type.name
      when "Date", "Time"
        date_field name
      else
        text_field name
      end
    end

    def scopes_selector
      return if object.user.blank?

      collection_select :scope_id, object.user.organization.scopes, :id, ->(scope) { translated_attribute(scope.name) }
    end
  end
end

Decidim::AuthorizationFormBuilder.send(:include, AuthorizationFormBuilderExtend)
