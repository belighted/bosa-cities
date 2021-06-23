# frozen_string_literal: true

require "decidim/core"

namespace :db do
  Rails.logger = Logger.new(STDOUT)

  task copy_organization: :environment do
    service = CopyOrganizationService.new(
      organization_host: 'brucity.bosa.production.belighted.com',
      source_secret_key_base: ENV.fetch("BRUCITY_SECRET_KEY_BASE"),
      target_secret_key_base: Rails.application.secrets.secret_key_base,
      source_db_config: {
        adapter: "postgresql",
        encoding: "unicode",
        pool: ENV.fetch("RAILS_MAX_THREADS", 5),
        host: ENV.fetch("DATABASE_HOST", "localhost"),
        username: ENV.fetch("DATABASE_USERNAME", "postgres"),
        password: ENV.fetch("DATABASE_PASSWORD", "password1"),
        database: ENV.fetch("BRUCITY_DATABASE_NAME", "bosa_brucity_prod")
      }
    )
    service.call
  end
end

class CopyOrganizationService
  def initialize(options)
    @options = options
  end

  def call
    @_users_mapping = {}
    @_scope_types_mapping = {}
    @_scopes_mapping = {}
    @_assemblies_mapping = {}
    @_process_groups_mapping = {}
    @_processes_mapping = {}
    @_components_mapping = {}
    @_debates_mapping = {}
    @_meetings_mapping = {}
    @_comments_mapping = {}

    read_source_data

    ActiveRecord::Base.transaction do
      copy_organization

      copy_scopes
      copy_areas
      copy_users

      copy_content_blocks
      copy_static_pages
      copy_help_sections
      copy_translations

      copy_assemblies # + components
      copy_processes # + components

      # copy components data
      copy_blogs_posts
      copy_proposals
      copy_debates
      copy_meetings

      # raise ActiveRecord::Rollback
    end
  end

  private

  def with_source_db
    original_connection = ActiveRecord::Base.remove_connection
    ActiveRecord::Base.establish_connection(@options[:source_db_config])
    yield
  ensure
    ActiveRecord::Base.establish_connection(original_connection)
  end

  def read_source_data
    @source_org = nil
    with_source_db do
      @source_org = Decidim::Organization.
        includes(
          :scope_types, scopes: [:children],
          users: [:identities],
          area_types: [:areas],
          static_page_topics: [:pages]
        ).where(host: @options[:organization_host]).first
      @content_blocks = Decidim::ContentBlock.where(organization: @source_org).to_a
      @help_sections = Decidim::ContextualHelpSection.where(organization: @source_org).to_a
      @translation_sets = Decidim::TermCustomizer::TranslationSet.includes(:constraints, :translations).where(decidim_term_customizer_constraints: {decidim_organization_id: @source_org}).to_a
      @assemblies = Decidim::Assembly.includes(:children, :components, :members).where(organization: @source_org).to_a
      @process_groups = Decidim::ParticipatoryProcessGroup.where(organization: @source_org).to_a
      excluded_processes = %w(enq2020 Meudon movenohw Meudon2)
      @processes = Decidim::ParticipatoryProcess.includes(:components, :steps, :categories).where(organization: @source_org).where.not(slug: excluded_processes).to_a
      @components = Decidim::Component.all.to_a.select {|c| c.organization.id == @source_org.id}
      @blogs_posts = Decidim::Blogs::Post.includes(:endorsements, :comments).all.to_a.select {|p| p.organization.id == @source_org.id}
      @proposals = Decidim::Proposals::Proposal.includes(:component, :endorsements, :coauthorships).all.to_a.select {|e| e.component.organization.id == @source_org.id}
      @debates = Decidim::Debates::Debate.includes(:component, :author, :comments).all.to_a.select {|d| d.component.organization.id == @source_org.id}
      @meetings = Decidim::Meetings::Meeting.includes(:component, :organizer, :comments).all.to_a.select {|m| m.component.organization.id == @source_org.id}
    end
  end

  def copy_organization
    @target_org = Decidim::Organization.new(@source_org.attributes.except('id'))

    smtp_password = ''
    omniauth_settings = {}
    begin
      Rails.application.secrets.secret_key_base = @options[:source_secret_key_base]
      smtp_password = Decidim::AttributeEncryptor.decrypt(@source_org.smtp_settings['encrypted_password'])
      omniauth_settings = Hash[(@source_org.omniauth_settings || []).map do |k, v|
        [k, Decidim::OmniauthProvider.value_defined?(v) ? Decidim::AttributeEncryptor.decrypt(v) : v]
      end]
    ensure
      Rails.application.secrets.secret_key_base = @options[:target_secret_key_base]
    end
    @target_org.smtp_settings.merge('encrypted_password' => Decidim::AttributeEncryptor.encrypt(smtp_password))
    @target_org.omniauth_settings = Hash[omniauth_settings.map do |k, v|
      [k, Decidim::OmniauthProvider.value_defined?(v) ? Decidim::AttributeEncryptor.encrypt(v) : v]
    end]
    @target_org.save!

    @org_id_attr = {"decidim_organization_id" => @target_org.id}
  end

  def copy_users
    @source_org.users.each do |source_user|
      user = @target_org.users.create!(source_user.attributes.except('id').merge("tos_agreement": true))
      @_users_mapping[source_user.id] = user.id
      source_user.identities.each do |source_identity|
        user.identities.create!(source_identity.attributes.except('id').merge(@org_id_attr))
      end
    end

    @source_org.users.select {|s| !s.invited_by_id.nil?}.each do |source_user|
      @target_org.users.find(@_users_mapping[source_user.id]).update_column(:invited_by_id, @_users_mapping[source_user.invited_by_id])
    end
  end

  def copy_scopes
    @source_org.scope_types.each do |source_scope_type|
      scope_type = @target_org.scope_types.create!(source_scope_type.attributes.except('id').merge(@org_id_attr))
      @_scope_types_mapping[source_scope_type.id] = scope_type.id
    end

    @source_org.scopes.select {|s| s.parent_id.nil?}.each do |source_parent_scope|
      parent_scope = @target_org.scopes.create!(source_parent_scope.attributes.except('id').
        merge(@org_id_attr).
        merge("scope_type_id": @_scope_types_mapping[source_parent_scope.scope_type_id])
      )
      parent_scope.send(:create_part_of)
      @_scopes_mapping[source_parent_scope.id] = parent_scope.id
      source_parent_scope.children.each do |source_child_scope|
        child_scope = @target_org.scopes.create!(source_child_scope.attributes.except('id').
          merge(@org_id_attr).
          merge("scope_type_id": @_scope_types_mapping[source_child_scope.scope_type_id]).
          merge("parent_id": parent_scope.id)
        )
        child_scope.send(:create_part_of)
        @_scopes_mapping[source_child_scope.id] = child_scope.id
      end
    end
  end

  def copy_areas
    @source_org.area_types.each do |source_area_type|
      area_type = @target_org.area_types.create!(source_area_type.attributes.except('id'))
      source_area_type.areas.each do |source_area|
        area_type.areas.create!(source_area.attributes.except('id', 'area_type_id').merge(@org_id_attr))
      end
    end
  end

  def copy_content_blocks
    @content_blocks.each do |source_content_block|
      Decidim::ContentBlock.create!(source_content_block.attributes.except('id').merge(@org_id_attr))
    end
  end

  def copy_static_pages
    @source_org.static_page_topics.each do |source_topic|
      topic = @target_org.static_page_topics.create!(source_topic.attributes.except('id'))
      source_topic.pages.each do |source_page|
        topic.pages.create!(source_page.attributes.except('id', 'topic_id').merge(@org_id_attr))
      end
    end
  end

  def copy_help_sections
    @help_sections.each do |source_help_section|
      Decidim::ContextualHelpSection.create!(source_help_section.attributes.except('id').merge({'organization_id' => @target_org.id}))
    end
  end

  def copy_translations
    @translation_sets.each do |source_translation_set|
      translation_set = Decidim::TermCustomizer::TranslationSet.create!(source_translation_set.attributes.except('id'))

      source_translation_set.constraints.each do |source_constraint|
        translation_set.constraints.create!(source_constraint.attributes.except('id').merge(@org_id_attr))
      end

      source_translation_set.translations.each do |source_translation|
        translation_set.translations.create!(source_translation.attributes.except('id'))
      end
    end
  end

  def copy_assemblies
    @assemblies.select {|s| s.parent_id.nil?}.each do |source_parent_assembly|
      parent_assembly = Decidim::Assembly.create!(source_parent_assembly.attributes.except('id').
        merge(@org_id_attr).
        merge("decidim_scope_id": @_scopes_mapping[source_parent_assembly.decidim_scope_id])
      )
      @_assemblies_mapping[source_parent_assembly.id] = parent_assembly.id
      _copy_components(source_parent_assembly, parent_assembly)
      _copy_assembly_members(source_parent_assembly, parent_assembly)
      source_parent_assembly.children.each do |source_child_assembly|
        child_assembly = Decidim::Assembly.create!(source_child_assembly.attributes.except('id').
          merge(@org_id_attr).
          merge("decidim_scope_id": @_scopes_mapping[source_child_assembly.decidim_scope_id]).
          merge("parent_id": parent_assembly.id)
        )
        @_assemblies_mapping[source_child_assembly.id] = child_assembly.id
        _copy_components(source_child_assembly, child_assembly)
        _copy_assembly_members(source_child_assembly, child_assembly)
      end
      Decidim::Assembly.reset_counters(parent_assembly.id, :children)
    end
  end

  def _copy_assembly_members(source, target)
    source.members.each do |source_member|
      target.members.create!(source_member.attributes.except('id', 'decidim_assembly_id').
        merge("decidim_user_id": @_users_mapping[source_member.decidim_user_id])
      )
    end
  end

  def copy_processes
    @process_groups.each do |source_group|
      group = Decidim::ParticipatoryProcessGroup.create!(source_group.attributes.except('id').merge(@org_id_attr))
      @_process_groups_mapping[source_group.id] = group.id
    end

    @processes.each do |source_process|
      process = Decidim::ParticipatoryProcess.create!(source_process.attributes.except('id').
        merge(@org_id_attr).
        merge("decidim_scope_id": @_scopes_mapping[source_process.decidim_scope_id]).
        merge("decidim_scope_type_id": @_scope_types_mapping[source_process.decidim_scope_type_id]).
        merge("decidim_participatory_process_group_id": @_process_groups_mapping[source_process.decidim_participatory_process_group_id])
      )
      @_processes_mapping[source_process.id] = process.id
      _copy_components(source_process, process)
      _copy_categories(source_process, process)

      source_process.steps.each do |source_step|
        process.steps.create!(source_step.attributes.except('id', 'decidim_participatory_process_id'))
      end
    end
  end

  def _copy_components(source, target)
    source.components.each do |source_component|
      component = target.components.create!(source_component.attributes.except('id', 'participatory_space_id'))
      @_components_mapping[source_component.id] = component.id
    end
  end

  def _copy_categories(source, target)
    source.categories.each do |source_category|
      target.categories.create!(source_category.attributes.except('id', 'decidim_participatory_space_id'))
    end
  end

  def copy_blogs_posts
    @blogs_posts.each do |source_post|
      post = Decidim::Blogs::Post.create!(source_post.attributes.except('id').
        merge("decidim_component_id": @_components_mapping[source_post.decidim_component_id]).
        merge("decidim_author_id": @_users_mapping[source_post.decidim_author_id])
      )
      _copy_endorsements(source_post, post)
    end
  end

  def copy_proposals
    @proposals.each do |source_proposal|
      proposal = Decidim::Proposals::Proposal.new(source_proposal.attributes.except('id').
        merge("decidim_component_id": @_components_mapping[source_proposal.decidim_component_id]).
        merge("decidim_scope_id": @_scopes_mapping[source_proposal.decidim_scope_id])
      )
      source_proposal.coauthorships.each do |coauthorship|
        coauthor = Decidim::User.where(id: @_users_mapping[coauthorship.decidim_author_id]).first
        proposal.add_coauthor(coauthor) if coauthor.present?
      end
      # there was an admin user from other org as coauthor, replace him with current org admin
      proposal.add_coauthor(@target_org.admins.last) unless proposal.valid?
      proposal.save!
      _copy_endorsements(source_proposal, proposal)
    end
  end

  def _copy_endorsements(source, target)
    source.endorsements.each do |source_endorsement|
      target.endorsements.create!(source_endorsement.attributes.except('id', 'resource_id').
        merge("decidim_author_id": @_users_mapping[source_endorsement.decidim_author_id])
      )
    end
  end

  def copy_debates
    @debates.each do |source_debate|
      debate = Decidim::Debates::Debate.create!(source_debate.attributes.except('id').
        merge("decidim_component_id": @_components_mapping[source_debate.decidim_component_id]).
        merge("decidim_author_id": @_users_mapping[source_debate.decidim_author_id])
      )
      @_debates_mapping[source_debate.id] = debate.id
    end
  end

  def copy_meetings
    @meetings.each do |source_meeting|
      meeting = Decidim::Meetings::Meeting.create!(source_meeting.attributes.except('id').
        merge("decidim_component_id": @_components_mapping[source_meeting.decidim_component_id]).
        merge("decidim_scope_id": @_scopes_mapping[source_meeting.decidim_scope_id]).
        merge("decidim_author_id": @_users_mapping[source_meeting.decidim_author_id]).
        merge("organizer_id": @_users_mapping[source_meeting.organizer_id])
      )
      @_meetings_mapping[source_meeting.id] = meeting.id
    end
  end

  def _copy_comments(source, target)
    source.comments.select {|c| c.decidim_commentable_type != 'Decidim::Comments::Comment'}.each do |source_comment|
      comment = Decidim::Comments::Comment.create!(source_comment.attributes.except('id').
        merge("decidim_commentable_id": target.id).
        merge("decidim_root_commentable_id": target.id).
        merge("decidim_author_id": @_users_mapping[source_comment.decidim_author_id])
      )
      @_comments_mapping[source_comment.id] = comment.id
    end

    # comments on comments
    source.comments.select {|c| c.decidim_commentable_type == 'Decidim::Comments::Comment'}.each do |source_comment|
      comment = Decidim::Comments::Comment.create!(source_comment.attributes.except('id').
        merge("decidim_commentable_id": @_comments_mapping[source_comment.decidim_commentable_id]).
        merge("decidim_root_commentable_id": target.id).
        merge("decidim_author_id": @_users_mapping[source_comment.decidim_author_id])
      )
      @_comments_mapping[source_comment.id] = comment.id
    end
  end

end
