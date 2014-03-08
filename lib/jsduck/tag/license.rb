module JsDuck::Tag
  class License < Ignore
    def initialize
      @tagname = :ignore
      @pattern = "license"
    end
  end
end
