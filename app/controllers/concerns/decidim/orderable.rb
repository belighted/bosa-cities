# frozen_string_literal: true

require "active_support/concern"

module Decidim
  # Common logic to ordering resources
  module Orderable
    extend ActiveSupport::Concern

    included do
      helper_method :order, :available_orders, :random_seed

      private

      # Gets how the proposals should be ordered based on the choice
      # made by the user.
      def order
        store_order_in_session
        @order ||= detect_order(params[:order]) || session_stored_order || default_order
      end

      def detect_order(candidate)
        available_orders.detect {|order| order == candidate}
      end

      def store_order_in_session
        _order = params[:order].present? && detect_order(params[:order])
        if _order.present?
          session["#{params[:controller]}_order"] = _order
        end
      end

      def session_stored_order
        detect_order(session["#{params[:controller]}_order"])
      end

      def default_order
        "random"
      end

      # Returns: A random float number between -1 and 1 to be used as a
      # random seed at the database.
      def random_seed
        @random_seed ||= begin
          session[:random_seed] ||= rand * 2 - 1
        end.to_f
      end
    end
  end
end
