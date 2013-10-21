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
    "at 12:00am on every day of the month"
  end
end
