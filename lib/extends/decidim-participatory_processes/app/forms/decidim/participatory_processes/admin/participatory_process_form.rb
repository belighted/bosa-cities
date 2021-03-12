# frozen_string_literal: true

require "active_support/concern"

module AdminParticipatoryProcessFormExtend
  extend ActiveSupport::Concern

  included do

    attribute :area_ids, Array[Integer]

  end
end

Decidim::ParticipatoryProcesses::Admin::ParticipatoryProcessForm.send(:include, AdminParticipatoryProcessFormExtend)
