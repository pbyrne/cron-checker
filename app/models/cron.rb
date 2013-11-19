require "date"
require "time"

class Cron
  attr_accessor :command,
    :minute, :hour,
    :day_of_month, :month,
    :day_of_week,
    :schedule_keyword


  def initialize(attrs = {})
    attrs.each do |key, value|
      self.send("#{key}=", value)
    end
  end

  def schedule_description
    if schedule_keyword == "@reboot"
      "when the computer reboots"
    elsif schedule_keyword
      options =
        case schedule_keyword
        when "@annually", "@yearly"
          {minute: "0", hour: "0", day_of_month: "1", month: "1"}
        when "@hourly"
          {minute: "0", hour: "*", day_of_month: "*", month: "*"}
        when "@daily", "@midnight"
          {minute: "0", hour: "0", day_of_month: "*", month: "*"}
        when "@monthly"
          {minute: "0", hour: "0", day_of_month: "1", month: "*"}
        end
      Cron.new(options.merge(command: command, day_of_week: "*")).schedule_description
    else
      "#{time_fragment} #{date_fragment} #{weekday_fragment}"
    end
  end

private

  def time_fragment
    Representations::Time.new(minute: minute, hour: hour)
  end

  def date_fragment
    if day_of_month == "*" and month == "*"
      "every day"
    else
      fragments = []

      if day_of_month == "*"
        fragments << "every day"
      else
        fragments << ordinalize(day_of_month)
      end
      fragments << "of"

      if month == "*"
        fragments << "every month"
      else
        fragments << Date::MONTHNAMES[month.to_i]
      end

      fragments.join(" ")
    end
  end

  def weekday_fragment
    unless day_of_week == "*"
      "and #{Date::DAYNAMES[day_of_week.to_i]}s"
    end
  end

  # FIXME remove this in deference to what exists in Representations::Base
  def ordinalize(number)
    suffix =
      case number.to_s.split("").last
      when "1"; "st"
      when "2"; "nd"
      when "3"; "rd"
      else; "th"
      end

    "#{number}#{suffix}"
  end
end
