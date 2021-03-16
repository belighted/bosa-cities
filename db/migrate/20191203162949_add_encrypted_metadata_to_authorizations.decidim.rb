# This migration comes from decidim (originally 20191004194247)


# nano db/migrate/20191203162949_add_encrypted_metadata_to_authorizations.decidim.rb


class AddEncryptedMetadataToAuthorizations < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_authorizations, :encrypted_metadata, :text
    Decidim::Authorization.find_each do |authorization|
      authorization.encrypted_metadata = Decidim::Verifications::Omniauth::MetadataEncryptor.new(
        uid: authorization.unique_id
      ).encrypt(authorization[:metadata])
    end
    remove_column :decidim_authorizations, :metadata
  end
end
