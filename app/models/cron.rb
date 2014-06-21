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
      "#{time_fragment} #{date_fragment}".strip
    end
  end

private

  def time_fragment
    Representations::Time.new(minute: minute, hour: hour)
  end

  def date_fragment
    Representations::Date.new({
      day: day_of_month,
      month: month,
      weekday: day_of_week,
    })
  end

  def weekday_fragment
    Representations::Weekday.new({
      weekday: day_of_week,
    })
  end

end
