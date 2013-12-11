module Representations
  class Time < Base
    attr_accessor :minute
    attr_accessor :hour

    def initialize(**values)
      self.minute = values.fetch(:minute)
      self.hour = values.fetch(:hour)
    end

    def to_s
      if vanilla_time?
        repr = "2013-01-01 #{hour}:#{minute}"
        format = "%l:%M%P" # 1:23pm
        "at #{::Time.parse(repr).strftime(format)}"
      else
        "#{minute_fragment} of #{hour_fragment}"
      end
    end

  protected

    def vanilla_time?
      return false if minute == "*" || hour == "*" # every
      return false if minute =~ /-/ || hour =~ /-/ # range
      return false if minute =~ /,/ || hour =~ /,/ # list
      true
    end

    def minute_fragment
      if minute == "*"
        "every minute"
      elsif minute =~ /-/
        first, last = minute.split("-")
        "the #{ordinalize(first)} through #{ordinalize(last)} minutes"
      elsif minute =~ /,/
        minutes = minute.split(",").map { |m| ordinalize(m) }
        "the #{minutes.join(" and ")} minutes"
      else
        "the #{ordinalize(minute)} minute"
      end
    end

    def hour_fragment
      if hour == "*"
        "every hour"
      elsif hour =~ /-/
        first, last = hour.split("-")
        "#{bare_hour(first)} through #{bare_hour(last)}"
      elsif hour =~ /,/
        hours = hour.split(",").map { |h| bare_hour(h) }
        hours.join(" and ")
      else
        bare_hour
      end
    end

    def bare_hour(hour_value = hour)
      repr = "2013-01-01 #{hour_value}:00"
      format = "%l%P" # 01pm
      ::Time.parse(repr).strftime(format).tr(" ", "")
    end
  end
end
