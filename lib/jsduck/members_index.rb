require 'jsduck/logger'

module JsDuck

  # Helper for JsDuck::Class for indexing its members.
  #
  # While indexing the members of a class it accesses the MembersIndex
  # instances of parent and mixins of that class through the
  # #members_index accessor.  This isn't the nicest approach, but
  # better than having all of this functionality inside the
  # JsDuck::Class itself.
  class MembersIndex
    def initialize(cls)
      @cls = cls
      @map_by_id = nil
      @global_map_by_id = nil
      @global_map_by_name = nil
    end

    # Returns hash of all members by name (including inherited ones)
    def global_by_name
      unless @global_map_by_name
        @global_map_by_name = {}

        global_by_id.each_pair do |id, m|
          @global_map_by_name[m[:name]] = [] unless @global_map_by_name[m[:name]]
          @global_map_by_name[m[:name]] << m
        end
      end

      @global_map_by_name
    end

    # Returns array of all members (including inherited ones)
    def all_global
      global_by_id.values
    end

    # Returns array of all local members (excludes inherited ones)
    def all_local
      local_by_id.values.reject {|m| m[:hide] }
    end

    # Clears the search cache.
    #
    # Using this degrades performance. It's currently triggered just
    # once after InheritDoc process is run. Avoid using it in other
    # places.
    def invalidate!
      @map_by_id = nil
      @global_map_by_id = nil
      @global_map_by_name = nil
    end

    protected

    # Returns hash of all members by ID (including inherited ones)
    def global_by_id
      unless @global_map_by_id

        @global_map_by_id = {}

        # Start with interfaces first.
        @cls.self_implements.each do |int|
          merge!(@global_map_by_id, int.members_index.global_by_id)
        end

        # Merge parent class members.
        if @cls.parent
          merge!(@global_map_by_id, @cls.parent.members_index.global_by_id)
        end

        # Merge mixin members then.
        @cls.mixins.each do |mix|
          merge!(@global_map_by_id, mix.members_index.global_by_id)
        end

        # Exclude all non-inheritable static members
        @global_map_by_id.delete_if {|id, m| m[:static] && !m[:inheritable] }

        merge!(@global_map_by_id, local_by_id)
      end

      @global_map_by_id
    end

    # Returns hash of local members by ID (no inherited members)
    def local_by_id
      unless @map_by_id
        @map_by_id = {}

        @cls[:members].each do |m|
          @map_by_id[m[:id]] = m
        end
      end

      @map_by_id
    end

    private

    # merges second members hash into first one
    def merge!(hash1, hash2)
      hash2.each_pair do |name, m|
        if m[:hide]
          if hash1[name]
            hash1.delete(name)
          else
            msg = "@hide used but #{m[:tagname]} #{m[:name]} not found in parent class"
            Logger.warn(:hide, msg, m[:files][0])
          end
        else
          if hash1[name]
            store_overrides(hash1[name], m)
          end
          hash1[name] = m
        end
      end
    end

    # Invoked when merge! finds two members with the same name.
    # New member always overrides the old, but inside new we keep
    # a list of members it overrides.  Normally one member will
    # override one other member, but a member from mixin can override
    # multiple members - although there's not a single such case in
    # ExtJS, we have to handle it.
    #
    # Every overridden member is listed just once.
    def store_overrides(old, new)
      # Sometimes a class is included multiple times (like Ext.Base)
      # resulting in its members overriding themselves.  Because of
      # this, ignore overriding itself.
      if new[:owner] != old[:owner]
        new[:overrides] = [] unless new[:overrides]
        unless new[:overrides].any? {|m| m[:owner] == old[:owner] }
          # Make a copy of the important properties for us.  We can't
          # just push the actual `old` member itself, because there
          # can be circular overrides (notably with Ext.Base), which
          # will result in infinite loop when we try to convert our
          # class into JSON.
          new[:overrides] << {
            :name => old[:name],
            :owner => old[:owner],
          }
        end
      end
    end

  end

end
