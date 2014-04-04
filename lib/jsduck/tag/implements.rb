require "jsduck/tag/class_list_tag"

module JsDuck::Tag
  class Implements < ClassListTag
    def initialize
      @pattern = ["implements", "implement"]
      @tagname = :implements
      @repeatable = true
      @ext_define_pattern = "implements"
      @ext_define_default = {:implements => []}
    end

    # Override definition in parent class.  In addition to Array
    # literal, implements can be defined with an object literal.
    def parse_ext_define(cls, ast)
      cls[:implements] = to_implements_array(ast)
    end

    # converts AstNode, whether it's a string, array or hash into
    # array of strings (when possible).
    def to_implements_array(ast)
      v = ast.to_value
      implements = v.is_a?(Hash) ? v.values : Array(v)
      implements.all? {|mx| mx.is_a? String } ? implements : []
    end
  end
end
