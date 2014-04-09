require "jsduck/tag/boolean_tag"

module JsDuck::Tag
  class Singleton < BooleanTag
    def initialize
      @pattern = "singleton"
      @ext_define_pattern = "singleton"
      @class_icon = {
        :icon => File.dirname(__FILE__) + "/icons/singleton.png",
        :priority => PRIORITY_SINGLETON,
      }
      @signature = {:long => "singleton", :short => "single"}
      @css = <<-EOCSS
        .signature .singleton {
          background-color: transparent;
          color: #929292;
        }
      EOCSS
      super
    end

    def parse_ext_define(cls, ast)
      cls[:singleton] = (ast.to_value == true)
    end
  end
end
