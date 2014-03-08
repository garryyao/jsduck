require "jsduck/tag/tag"
require "jsduck/tag/boolean_tag"

# See https://github.com/senchalabs/jsduck/wiki/Custom-tags

module JsDuck::Tag
  # Introduce "handler" as a separate class member.
  class Handler < MemberTag
    def initialize
      @pattern = "handler"
      @tagname = :handler
      @member_type = {
          :title => "Handlers",
          :position => MEMBER_POS_METHOD + 0.1,
          :icon => File.dirname(__FILE__) + "/icons/handler.png"
      }
    end

    # @event name ...
    def parse_doc(p, pos)
      {
          :tagname => :handler,
          :name => p.ident,
      }
    end

    def process_doc(h, tags, pos)
      h[:name] = tags[0][:name]
    end

    def merge(h, docs, code)
      JsDuck::ParamsMerger.merge(h, docs, code)
    end

    def to_html(event, cls)
      member_link(event) + member_params(event[:params])
    end
  end
end
