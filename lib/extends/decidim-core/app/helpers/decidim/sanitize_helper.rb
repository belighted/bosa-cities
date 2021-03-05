# frozen_string_literal: true

require "active_support/concern"

module SanitizeHelperExtend
  extend ActiveSupport::Concern

  included do

    def decidim_html_escape(text)
      # Do not use `html_safe` here for security reasons, we just don't want single quote symbols to be escaped
      ERB::Util.unwrapped_html_escape(text.to_str).gsub("&#39;", "'")
    end

  end
end

Decidim::SanitizeHelper.send(:include, SanitizeHelperExtend)
