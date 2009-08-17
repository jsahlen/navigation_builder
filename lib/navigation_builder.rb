module ApplicationHelper

  class NavigationBuilder
    include ActionView::Helpers
    include Haml::Helpers

    attr_accessor :active, :active_class, :haml_buffer

    def initialize(active, active_class, haml_buffer)
      @active = active.to_s
      @active_class, @haml_buffer = active_class, haml_buffer
    end

    def item(label, link, options={})
      options.stringify_keys!

      tag = options["tag"] || "li"
      identifier = options["identifier"] ? options["identifier"].to_s : label.downcase

      options.delete "tag"
      options.delete "identifier"

      options["class"] = identifier == active ? active_class : nil

      capture_haml do
        haml_tag tag, options do
          haml_tag :a, label, { :href => link }
        end
      end
    end
  end

  def navigation_menu(options={}, &block)
    raise ArgumentError, "Missing block" unless block_given?

    options.stringify_keys!

    tag = options["tag"] || "ul"
    active = options["active"] || ""
    active_class = options["active_class"] || "active"

    options.delete "tag"
    options.delete "active"
    options.delete "active_class"

    haml_tag tag, options do
      yield NavigationBuilder.new(active, active_class, @haml_buffer)
    end
  end

end