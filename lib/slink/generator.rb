module Slink
  class Generator

    def initialize(definition)
      @definition = definition
    end

    def generate(data)
      @builder = []
      @definition.sections.each do |section|
        content = data[section.name]
        if content
          content = [content] unless content.is_a?(Array)
          raise("Required section '#{section.name}' was empty.") if content.empty?
          content.each do |row|
            @builder << section.format(row)
          end
        else
          raise("Required section '#{section.name}' was empty.") unless section.optional
        end
      end
      if @definition.options[:trailing_blank_line]
        @builder << "" + @definition.options[:new_line]
      end
      @builder.join("")
    end

  end
end
