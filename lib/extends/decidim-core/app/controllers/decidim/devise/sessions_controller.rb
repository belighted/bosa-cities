# frozen_string_literal: true

require "active_support/concern"

module DeviseSessionsControllerExtend
  extend ActiveSupport::Concern

  included do
    def after_sign_out_path_for(user)
      decidim.new_user_session_path
    end
  end
end

Decidim::Devise::SessionsController.send(:include, DeviseSessionsControllerExtend)

