require "jsduck/tag/boolean_tag"

module JsDuck::Tag
  class Interface < BooleanTag
    def initialize
      @pattern = "interface"
      @class_icon = {
          :small => File.dirname(__FILE__) + "/icons/interface.png",
          :large => File.dirname(__FILE__) + "/icons/interface-large.png",
          :redirect => File.dirname(__FILE__) + "/icons/interface-redirect.png",
          :priority => PRIORITY_SINGLETON,
      }
      @signature = {:long => "interface", :short => "int"}
      @css = <<-EOCSS
        .signature .interface {
          background-color: transparent;
          color: #e3e3e3;
        }
      EOCSS
      super
    end
  end
end
