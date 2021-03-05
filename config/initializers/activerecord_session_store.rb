# frozen_string_literal: true

require "active_support/concern"

module ActiveRecordSessionStoreExtend
  extend ActiveSupport::Concern

  included do

    def serialize(data)
      if data
        # Skip storing attachment on create initiative/suggestion to prevent issues with non utf characters in filename
        data['initiative']['attachment'] = nil if data.dig('initiative', 'attachment').present?
        data['suggestion']['attachment'] = nil if data.dig('suggestion', 'attachment').present?
        serializer_class.dump(data)
      end
    end

  end
end

ActiveRecord::SessionStore::ClassMethods.send(:include, ActiveRecordSessionStoreExtend)
