# frozen_string_literal: true

require "active_support/concern"

module FormBuilderExtend
  extend ActiveSupport::Concern

  included do

    def date_field(attribute, options = {})
      value = object.send(attribute)
      data = { datepicker: "" }
      data[:startdate] = I18n.localize(value, format: :decidim_short) if value.present? && value.is_a?(Date)
      datepicker_format = ruby_format_to_datepicker(I18n.t("date.formats.decidim_short"))
      data[:"date-format"] = datepicker_format

      template = text_field(
        attribute,
        options.merge(data: data)
      )
      help_text = I18n.t("decidim.datepicker.help_text", datepicker_format: datepicker_format)
      template += content_tag(:p, help_text, class: "help-text") if help_text.present?
      template.html_safe
    end

    def datetime_field(attribute, options = {})
      value = object.send(attribute)
      data = { datepicker: "", timepicker: "" }
      data[:startdate] = I18n.localize(value, format: :decidim_short) if value.present? && value.is_a?(ActiveSupport::TimeWithZone)
      datepicker_format = ruby_format_to_datepicker(I18n.t("time.formats.decidim_short"))
      data[:"date-format"] = datepicker_format

      template = text_field(
        attribute,
        options.merge(data: data)
      )
      help_text = I18n.t("decidim.datepicker.help_text", datepicker_format: datepicker_format)
      template += content_tag(:p, help_text, class: "help-text") if help_text.present?
      template.html_safe
    end

    # rubocop:disable Metrics/PerceivedComplexity
    def upload(attribute, options = {})
      self.multipart = true
      options[:optional] = options[:optional].nil? ? true : options[:optional]

      file = object.send attribute
      template = ""
      template += label(attribute, label_for(attribute) + required_for_attribute(attribute))
      template += if options[:accept].present?
                    @template.file_field @object_name, attribute, accept: options.delete(:accept)
                  else
                    @template.file_field @object_name, attribute, style: 'width: 95%'
                  end
      if options[:clear_icon]
        template += @template.icon_link_to('circle-x', '', I18n.t("actions.destroy", scope: "decidim.admin"), class: 'clear-attachment float-right')
      end

      if file_is_image?(file)
        template += if file.present?
                      @template.content_tag :label, I18n.t("current_image", scope: "decidim.forms")
                    else
                      @template.content_tag :label, I18n.t("default_image", scope: "decidim.forms")
                    end
        template += @template.link_to @template.image_tag(file.url), file.url, target: "_blank", rel: "noopener"
      elsif file_is_present?(file)
        template += @template.label_tag I18n.t("current_file", scope: "decidim.forms")
        template += @template.link_to file.file.filename, file.url, target: "_blank", rel: "noopener"
      end

      if file_is_present?(file)
        if options[:optional]
          template += content_tag :div, class: "field" do
            safe_join([
                        @template.check_box(@object_name, "remove_#{attribute}"),
                        label("remove_#{attribute}", I18n.t("remove_this_file", scope: "decidim.forms"))
                      ])
          end
        end
      end

      if object.errors[attribute].any?
        template += content_tag :p, class: "is-invalid-label" do
          safe_join object.errors[attribute], "<br/>".html_safe
        end
      end

      template.html_safe
    end
    # rubocop:enable Metrics/PerceivedComplexity

  end
end

Decidim::FormBuilder.send(:include, FormBuilderExtend)
