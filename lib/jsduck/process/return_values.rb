module JsDuck
  module Process

    # Auto-detector return values and @chainable tags.
    #
    # Adds @chainable tag when doc-comment contains @return {OwnerClass}
    # this.  Also the other way around: when @chainable found, adds
    # appropriate @return.
    class ReturnValues
      def initialize(relations)
        @relations = relations
        @cls = nil
      end

      def process_all!
        @relations.each do |cls|
          @cls = cls
          cls.find_members(:tagname => :method, :local => true).each do |m|
            process(m)
          end
        end
      end

      private

      def process(m)
        if constructor?(m)
          add_return_new(m)
        elsif returns_this?(m) || chainable?(m)
          add_return_this(m)
        end
      end

      def constructor?(m)
        m[:name] == "constructor"
      end

      def chainable?(m)
        m[:chainable]
      end

      def returns_this?(m)
        t = m[:return] && m[:return][:doc] =~ /\Athis\b/
        if t
          m[:return][:doc] = nil
        end
        t
      end

      def add_chainable(m)
        m[:chainable] = true
      end

      def add_return_this(m)
        ret = m[:return] || (m[:return] = {})
        ret[:type] = @cls[:name]
        if ret[:name] == nil
          ret[:name] = "this"
        end

        if ret[:doc] == nil
          ret[:doc] = "Instance of this class."
        end

      end

      def add_return_new(m)
        if m[:return] == nil || m[:return][:type] == "Object"
          # Create a whole new :return hash.
          # If we were to just change the :type field it would modify
          # the type of all the inherited constructor docs.
          m[:return] = {
            :type => @cls[:name],
            :doc => m[:return] ? m[:return][:doc] : "",
          }
        end
      end
    end

  end
end
