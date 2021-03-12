# frozen_string_literal: true

require "active_support/concern"

module AdminAssemblyFormExtend
  extend ActiveSupport::Concern

  included do

    attribute :area_ids, Array[Integer]

  end
end

Decidim::Assemblies::Admin::AssemblyForm.send(:include, AdminAssemblyFormExtend)
