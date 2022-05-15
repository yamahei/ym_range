# frozen_string_literal: true

require "date"

module YmRange

  class Checker
    attr_reader :years, :months

    @years = []
    @months = []

    YEAR_FULL_RANGE = (0..9999).freeze
    MONTH_FULL_RANGE = (1..12).freeze

    def initialize(*arg)
      @years, @months = *parse_arguments(arg)
    end

    def include?(*arg) #=>boolean
      years, months = *parse_arguments(arg)
      year = years.shift
      month = months.shift

      return false unless @years.include?(year)
      return false unless @months.include?(month)
      return true
    end
    alias cover? include?
    # alias :cover? :include?

    private ####

    def parse_arguments(arguments) #=> [years, months]
      case
      when arguments.length.zero?
        parse_single_argument(Date.today) #=> [years, months]
      when arguments.length == 1
        parse_single_argument(arguments[0]) #=> [years, months]
      when arguments.length == 2
        parse_double_arguments(*arguments) #=> [years, months]
      else
        raise ArgumentError, "Less than 2 arguments required."
      end
    end

    def parse_single_argument(argument) #=> [years, months]
      case
      when argument.is_a?(Date)
        [[argument.year], [argument.month]]
      when argument.is_a?(String)
        parse_string_arguments(argument) #=> [years, months]
      else
        raise ArgumentError, "1 argument must be nil or Date, String."
      end
    end

    def parse_double_arguments(year, month) #=> [years, months]
      [
        parse_multi_type_argument("year", year, YEAR_FULL_RANGE, false),
        parse_multi_type_argument("month", month, MONTH_FULL_RANGE, true),
      ]
    end

    def parse_multi_type_argument(name, argument, full_range, allow_array) #=>(years|months)
      return full_range.to_a if argument.is_a?(NilClass)
      return [argument] if argument.is_a?(Integer) && full_range.include?(argument)
      if argument.is_a?(Range)
        return argument.to_a if full_range.cover?(argument)
        raise ArgumentError, "#{name} must be in #{full_range.to_s}."
      end
      if allow_array && argument.is_a?(Array)
        return argument.uniq if argument.all? {|e| full_range.include?(e) }
        raise ArgumentError, "#{name} must be in #{full_range.to_s}."
      end
      raise ArgumentError, "unknown argument for #{name}."
    end

    def parse_string_arguments(ym_string) #=> [years, months]
      ym_strings = ym_string.split("/")
      raise ArgumentError, "invalid ym-string: #{ym_string}" if ym_strings.length != 2

      year_string, month_string = *ym_strings
      parse_double_arguments(
        parse_single_string(year_string, YEAR_FULL_RANGE),
        parse_single_string(month_string, MONTH_FULL_RANGE)
      )
    end

    def parse_single_string(_pattern, full_range) #=>year or month argument data(not string)
      pattern = _pattern.gsub(/\s/, "")
      return nil if pattern == "*"
      return pattern.to_i if pattern =~ /^\d+$/
      if pattern =~ /^(\*|\d+)-(\*|\d+)$/
        from_str, to_str = pattern.split("-")
        from_i = from_str == "*" ? full_range.min : from_str.to_i
        to_i = to_str == "*" ? full_range.max : to_str.to_i
        return from_i..to_i
      end
      if pattern =~ /^\d+(,\d+)+$/
        entries = pattern.split(",")
        return entries.map(&:to_i)
      end
      raise ArgumentError, "unknown string argument: #{_pattern}."
    end

  end

end
