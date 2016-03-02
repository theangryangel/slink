module Slink
  class Definition
    attr_reader :sections, :options
    
    def initialize(options = {})
      @sections = []
      @options = { :separator => ',', :quote_char => '"', :new_line => "\n" }.merge(options)
    end
    
    def section(name, options = {}, &block)
      raise(ArgumentError, "Reserved or duplicate section name: '#{name}'") if  (@sections.size > 0 && @sections.map{ |s| s.name }.include?( name ))
    
      section = Slink::Section.new(name, @options.merge(options))
      section.definition = self
      yield(section)
      @sections << section
      section
    end
    
    def method_missing(method, *args, &block)
      section(method, *args, &block)
    end
  end  
end
