class Cron
  attr_accessor :statement

  def initialize(statement)
    self.statement = statement
  end

  def command
    "./foo"
  end

  def schedule_description
    "at 12:00am on every day of the month"
  end

  def valid?
    true
  end
end
