module Representations
  class Date < Base
    attr_accessor :day
    attr_accessor :month
    attr_accessor :weekday

    def initialize(**values)
      self.day = values.fetch(:day)
      self.month = values.fetch(:month)
      self.weekday = values.fetch(:weekday)
    end

    def to_s
      if day == "*" and month == "*" and weekday == "*"
        "every day"
      else
        "#{day_fragment} #{month_fragment}"
      end
    end

  protected

    def day_fragment
      if day == "*" and weekday == "*"
        "every day of"
      elsif day == "*"
        day_of_week_fragment
      elsif weekday == "*"
        day_of_month_fragment
      else
        [day_of_month_fragment, day_of_week_fragment].compact.join(" and ")
      end
    end

    def day_of_month_fragment
      fragment =
        if day == "*"
          "every day"
        elsif day =~ /-/
          first, last = day.split("-")
          "the #{ordinalize(first)} through #{ordinalize(last)}"
        elsif day =~ /,/
          days = day.split(",").map { |d| ordinalize(d) }
          "the #{days.join(" and ")}"
        elsif day =~ /\//
          _, d = day.split("/")
          "every #{ordinalize(d)} day"
        else
          "the #{ordinalize(day)}"
        end

      "#{fragment} of"
    end

    def day_of_week_fragment
      return if weekday == "*" || weekday.nil?# nil if not limited to a particular weekday

      fragment =
        if weekday =~ /-/
          first, last = weekday.split("-")
          "#{plural_weekday_name(first)} through #{plural_weekday_name(last)} in"
        elsif weekday =~ /,/
          days = weekday.split(",").map do |day|
            plural_weekday_name(day)
          end
          days.join(" and ")
        elsif weekday =~ /\//
          _, d = weekday.split("/")
          "every #{ordinalize(d)} weekday"
        else
          plural_weekday_name(weekday)
        end

      "#{fragment} in"
    end

    def month_fragment
      if month == "*"
        "every month"
      elsif month =~ /-/
        first, last = month.split("-")
        "#{month_name(first)} through #{month_name(last)}"
      elsif month =~ /,/
        months = month.split(",").map { |m| month_name(m) }
        months.join(" and ")
      elsif month =~ /\//
        _, m = month.split("/")
        "every #{ordinalize(m)} month"
      else
        month_name(month)
      end
    end

    def month_name(month_number)
      ::Date::MONTHNAMES[month_number.to_i]
    end

    # note Sunday at both the 0 and 7 slot
    DAY_NAMES = %w(Sundays Mondays Tuesdays Wednesdays Thursdays Fridays Saturdays Sundays)
    def plural_weekday_name(weekday_number)
      DAY_NAMES[weekday_number.to_i]
    end
  end
end
