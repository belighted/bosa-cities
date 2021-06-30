# frozen_string_literal: true

require "active_support/concern"

module UserPresenterExtend
  extend ActiveSupport::Concern

  included do

    def name
      ERB::Util.unwrapped_html_escape(__getobj__.name)
    end

  end
end

Decidim::UserPresenter.send(:include, UserPresenterExtend)
