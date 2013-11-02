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
        else
          {}
        end
      Cron.new(options.merge(command: command, day_of_week: "*")).schedule_description
    else
      "#{time_fragment} #{date_fragment} #{weekday_fragment}"
    end
  end

private

  def time_fragment
    if minute == "*" and hour == "*"
      "every minute of every hour of"
    else
      "at #{hour.to_s.rjust(2, "0")}:#{minute.to_s.rjust(2, "0")}"
    end
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
