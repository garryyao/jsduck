require "jsduck/tag/boolean_tag"

module JsDuck::Tag
  class Abstract < BooleanTag
    def initialize
      @pattern = "abstract"
      @class_icon = {
          :small => File.dirname(__FILE__) + "/icons/abstract.png",
          :large => File.dirname(__FILE__) + "/icons/abstract-large.png",
          :redirect => File.dirname(__FILE__) + "/icons/abstract-redirect.png",
          :priority => PRIORITY_SINGLETON,
      }
      @signature = {:long => "abstract", :short => "ABS"}
      super
    end
  end
end
