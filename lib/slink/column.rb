require 'date'

module Slink
  class Column
    attr_reader :name, :type, :options

    def initialize(name, options = {})
      @name = name
      @options = options
      @alignment = options[:align] || :right
      @type = options[:type] || :string
      @truncate = options[:truncate] || false
    end

    def parse(value)
      return if value.nil?

      case @type
        when :integer
          value.to_i
        when :float, :money
          value.to_f
        when :money_with_implied_decimal
          value.to_f / 100
        when :date
          if @options[:format]
            Date.strptime(value, @options[:format])
          else
            Date.strptime(value)
          end
        else value
      end
    rescue
      raise "Error parsing column ''#{name}'. The value '#{value}' could not be converted to type #{@type}: #{$!}"
    end

    def format(value)
      ("%s" % to_s(value))
    rescue
      puts "Could not format column '#{@name}' as a '#{@type}' with formatter '#{formatter}' and value of '#{value}' (formatted: '#{to_s(value)}'). #{$!}"
    end

    private

    def inspect
      "#<#{self.class} #{instance_variables.map{|iv| "#{iv}=>#{instance_variable_get(iv)}"}.join(', ')}>"
    end

    def to_s(value)
      return "" if value.nil?

      result = case @type
        when :date
          # If it's a DBI::Timestamp object, see if we can convert it to a Time object
          unless value.respond_to?(:strftime)
            value = value.to_time if value.respond_to?(:to_time)
          end
          if value.respond_to?(:strftime)
            if @options[:format]
              value.strftime(@options[:format])
            else
              value.strftime
            end
          else
            value.to_s
          end
        when :float
          @options[:format] ? @options[:format] % value.to_f : value.to_f.to_s
        when :money
          "%.2f" % value.to_f
        when :money_with_implied_decimal
          "%d" % (value.to_f * 100)
        else
          value.to_s
      end
      result
    end
  end
end
