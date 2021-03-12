# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module Initiatives
    module HasArea
      extend ActiveSupport::Concern

      included do
        belongs_to :area,
                   foreign_key: "decidim_area_id",
                   class_name: "Decidim::Area",
                   optional: true

        # delegate :areas, to: :organization # remove to use has_and_belongs_to_many relation
        has_and_belongs_to_many :areas, class_name: "Decidim::Area", join_table: "decidim_initiatives_areas",
                                foreign_key: "decidim_initiative_id", association_foreign_key: "decidim_area_id"

        validate :area_belongs_to_organization
      end

      private

      def area_belongs_to_organization
        return unless area && organization

        errors.add(:area, :invalid) unless organization.areas.where(id: area.id).exists?
      end
    end
  end
end
