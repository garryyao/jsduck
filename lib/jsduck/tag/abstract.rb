require "jsduck/tag/boolean_tag"

module JsDuck::Tag
  class Abstract < BooleanTag
    def initialize
      @pattern = "abstract"
      @class_icon = {
          :icon => File.dirname(__FILE__) + "/icons/abstract.png",
          :priority => PRIORITY_SINGLETON,
      }
      @signature = {:long => "abstract", :short => "ABS"}
      super
    end
  end
end
