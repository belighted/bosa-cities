# frozen_string_literal: true

require "active_support/concern"

module AdminOrganizationControllerExtend
  extend ActiveSupport::Concern

  included do

    def users
      respond_to do |format|
        format.json do
          if (term = params[:term].to_s).present?
            query = current_organization.users.order(name: :asc)
            query = if term.start_with?("@")
                      query.where("nickname ILIKE ?", "#{term.delete("@")}%")
                    else
                      query.where("name ILIKE ?", "%#{term}%").or(
                        query.where("email ILIKE ?", "%#{term}%")
                      )
                    end
            render json: query.all.collect {|u| {value: u.id, label: "#{u.name} (@#{u.nickname})"}}
          else
            render json: []
          end
        end
      end
    end

  end
end

Decidim::Admin::OrganizationController.send(:include, AdminOrganizationControllerExtend)
