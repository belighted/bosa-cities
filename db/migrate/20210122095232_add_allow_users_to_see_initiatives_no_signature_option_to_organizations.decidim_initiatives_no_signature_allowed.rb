# frozen_string_literal: true
# This migration comes from decidim_initiatives_no_signature_allowed (originally 20210122071505)

class AddAllowUsersToSeeInitiativesNoSignatureOptionToOrganizations < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_organizations, :allow_users_to_see_initiatives_no_signature_option, :boolean, default: true
  end
end
