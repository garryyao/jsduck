require "jsduck/tag/tag"
require "jsduck/logger"

module JsDuck::Tag
  class Fires < Tag
    def initialize
      @pattern = "fires"
      @tagname = :fires
      @repeatable = true
      @html_position = POS_FIRES
    end

    # @fires eventname
    def parse_doc(p, pos)
      tag = {:tagname => :fires}

      # event name from other class
      if p.look(/.+#/)
        tag[:cls] = p.ident_chain
        p.match(/#/)
        if p.look(/static-/)
          tag[:static] = true
          p.match(/static-/)
        end
        if p.look(JsDuck::MemberRegistry.regex)
          tag[:type] = p.match(/\w+/).to_sym
          p.match(/-/)
        end
        tag[:member] = p.ident
      # event name from own class
      else
        tag[:cls] = nil
        tag[:type] = :event
        tag[:member] = p.ident
      end

      tag
    end

    def process_doc(h, tags, pos)
      h[:fires] = tags.select {|t| t[:tagname] == :fires }
      h
    end

    def format(m, formatter)
      m[:fires] = m[:fires].map do |f|
        member = f[:member];
        owner = f[:cls] || m[:owner]

        # Check event existence.
        cls = formatter.relations[owner]
        if cls.find_members({:tagname => :event, :name => member}).length > 0
          formatter.link(owner, member, member, :event, m[:static])
        else
          JsDuck::Logger.warn(:fires, "@fires unknown event: #{label}", m[:files][0])
        end
      end
    end

    def to_html(m)
      return unless m[:fires] && m[:fires].length > 0

      return [
        "<h3 class='pa'>Fires</h3>",
        "<ul>",
          m[:fires].map {|e| "<li>#{e}</li>" },
        "</ul>",
      ]
    end
  end
end
