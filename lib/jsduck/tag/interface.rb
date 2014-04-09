require "jsduck/tag/boolean_tag"

module JsDuck::Tag
  class Interface < BooleanTag
    def initialize
      @pattern = "interface"
      @class_icon = {
          :icon => File.dirname(__FILE__) + "/icons/interface.png",
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
