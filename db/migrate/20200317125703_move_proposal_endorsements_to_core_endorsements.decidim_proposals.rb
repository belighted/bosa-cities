# frozen_string_literal: true
# This migration comes from decidim_proposals (originally 20200120215928)

# This migration must be executed after CreateDecidimEndorsements migration in decidim-core.


# nano db/migrate/20200317125703_move_proposal_endorsements_to_core_endorsements.decidim_proposals.rb

class MoveProposalEndorsementsToCoreEndorsements < ActiveRecord::Migration[5.2]
  class ProposalEndorsement < ApplicationRecord
    self.table_name = :decidim_proposals_proposal_endorsements
  end
  class Endorsement < ApplicationRecord
    self.table_name = :decidim_endorsements
  end
  # Move ProposalEndorsements to Endorsements
  def up
    non_duplicated_group_endorsements = ProposalEndorsement.select(
      "MIN(id) as id, decidim_user_group_id"
    ).group(:decidim_user_group_id).where.not(decidim_user_group_id: nil).map(&:id)

    ProposalEndorsement.where("id IN (?) OR decidim_user_group_id IS NULL", non_duplicated_group_endorsements).find_each do |prop_endorsement|
      attrs = {
        resource_type: Decidim::Proposals::Proposal.name,
        resource_id: prop_endorsement.decidim_proposal_id,
        decidim_author_type: prop_endorsement.decidim_author_type,
        decidim_author_id: prop_endorsement.decidim_author_id,
        decidim_user_group_id: prop_endorsement.decidim_user_group_id
      }
      e = ::Decidim::Endorsement.new(attrs)
      ::Decidim::Endorsement.create!(attrs) if e.valid?
    end
    # update new `decidim_proposals_proposal.endorsements_count` counter cache
    Decidim::Proposals::Proposal.select(:id).all.find_each do |proposal|
      Decidim::Proposals::Proposal.reset_counters(proposal.id, :endorsements)
    end
  end

  def down
    non_duplicated_group_endorsements = Endorsement.select(
      "MIN(id) as id, decidim_user_group_id"
    ).group(:decidim_user_group_id).where.not(decidim_user_group_id: nil).map(&:id)

    Endorsement
      .where(resource_type: "Decidim::Proposals::Proposal")
      .where("id IN (?) OR decidim_user_group_id IS NULL", non_duplicated_group_endorsements).find_each do |endorsement|
      ProposalEndorsement.find_or_create_by!(
        decidim_proposal_id: endorsement.resource_id,
        decidim_author_type: endorsement.decidim_author_type,
        decidim_author_id: endorsement.decidim_author_id,
        decidim_user_group_id: endorsement.decidim_user_group_id
      )
    end
    # update `decidim_proposals_proposal.proposal_endorsements_count` counter cache
    Decidim::Proposals::Proposal.select(:id).all.find_each do |proposal|
      Decidim::Proposals::Proposal.reset_counters(proposal.id, :proposal_endorsements)
    end
  end
end
