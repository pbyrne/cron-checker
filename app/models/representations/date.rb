module Representations
  class Date < Base
    attr_accessor :day
    attr_accessor :month

    def initialize(**values)
      self.day = values.fetch(:day)
      self.month = values.fetch(:month)
    end

    def to_s
      if day == "*" and month == "*"
        "every day"
      else
        "#{day_fragment} of #{month_fragment}"
      end
    end

  protected

    def day_fragment
      if day == "*"
        "every day"
      elsif day =~ /-/
        first, last = day.split("-")
        "the #{ordinalize(first)} through #{ordinalize(last)}"
      elsif day =~ /,/
        days = day.split(",").map { |d| ordinalize(d) }
        "the #{days.join(" and ")}"
      else
        "the #{ordinalize(day)}"
      end
    end

    def month_fragment
      if month == "*"
        "every month"
      elsif month =~ /-/
        first, last = month.split("-")
        "#{name_of(first)} through #{name_of(last)}"
      elsif month =~ /,/
        months = month.split(",").map { |m| name_of(m) }
        months.join(" and ")
      else
        name_of(month)
      end
    end

    def name_of(month_number)
      ::Date::MONTHNAMES[month_number.to_i]
    end
  end
end
