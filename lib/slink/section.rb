require 'csv'

module Slink
  class Section
    attr_accessor :definition, :optional
    attr_reader :name, :columns, :options

    RESERVED_NAMES = [:spacer]

    def initialize(name, options = {})
      @name = name
      @options = options
      @columns = []
      @trap = options[:trap]
      @optional = options[:optional] || false
    end

    def column(name, options = {})
      raise("You have already defined a column named '#{name}'.") if @columns.map do |c|
        RESERVED_NAMES.include?(c.name) ? nil : c.name
      end.flatten.include?(name)
      col = Column.new(name, @options.merge(options))
      @columns << col
      col
    end

    def spacer
      column(:spacer)
    end

    def trap(&block)
      @trap = block
    end

    def format(data)
      row = []
      @columns.each do |column|
        row << column.format(data[column.name])
      end

      if @options[:quote_char] == ''
        return row.join(@options[:separator])
      end

      row.to_csv(
        quote_char: @options[:quote_char],
        row_sep: @options[:new_line], 
        col_sep: @options[:separator],
        force_quotes: false
      )
    end

    def parse(line)
      line.chomp!
      if @options[:quote_char] == ''
        line_data = line.split(@options[:separator])
      else
        line_data = CSV.parse_line(line, col_sep: @options[:separator])
      end
      row = {}
      @columns.each_with_index do |c, i|
        row[c.name] = c.parse(line_data[i]) unless RESERVED_NAMES.include?(c.name)
      end
      row
    end

    def match(raw_line)
      raw_line.nil? ? false : @trap.call(raw_line)
    end

    def method_missing(method, *args)
      column(method, *args)
    end

  end
end
