require "date"

module Representations
  class Weekday < Base
    attr_accessor :weekday

    def initialize(**values)
      self.weekday = values.fetch(:weekday)
    end

    def to_s
      return "" if weekday == "*"

      "and #{weekday_fragment}"
    end

  private

    def weekday_fragment
      if weekday =~ /-/
        first, last = weekday.split("-")
        "#{plural_name_of(first)} through #{plural_name_of(last)}"
      elsif weekday =~ /,/
        days = weekday.split(",").map do |day|
          plural_name_of(day)
        end
        days.join(" and ")
      else
        plural_name_of(weekday)
      end
    end

    def plural_name_of(value)
      "#{::Date::DAYNAMES[value.to_i]}s"
    end
  end
end
