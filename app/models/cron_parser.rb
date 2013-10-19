class CronParser
  attr_accessor :statement

  SPECIAL_SCHEDULES = %w(@reboot @hourly @daily @midnight @monthly @yearly @annually)

  def initialize(statement = nil)
    self.statement = statement
  end

  def valid?
    return false unless statement.present?
    return false unless command.present?
    true
  end

  def cron
    raise MissingStatement unless statement.present?
    raise InvalidStatement unless valid?
    @cron ||= Cron.new
  end

private

  def special_schedule?
    SPECIAL_SCHEDULES.include? statement_fragments.first
  end

  def statement_fragments
    statement.split
  end

  def command
    if special_schedule?
      statement_fragments[1..-1]
    else
      statement_fragments[5..-1]
    end
  end

  InvalidStatement = Class.new(StandardError)
  MissingStatement = Class.new(StandardError)
end
