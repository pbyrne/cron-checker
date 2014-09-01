class CronParser
  attr_accessor :statement

  SPECIAL_SCHEDULES = %w(@reboot @hourly @daily @midnight @monthly @yearly @annually)

  def initialize(statement = nil)
    self.statement = statement
  end

  def valid?
    statement.present? && command.present?
  end

  def cron
    raise MissingStatement unless statement.present?
    raise InvalidStatement unless valid?

    Cron.new(cron_attributes)
  end

  def error_message
    if statement.blank?
      "You must provide a cron statement."
    elsif !valid?
      "Unrecognized cron statement '#{statement}'."
    end
  end

  def special_schedule?
    SPECIAL_SCHEDULES.include? statement_fragments.first
  end
  private :special_schedule?

  def statement_fragments
    statement.split
  end
  private :statement_fragments

  def command
    command_position = special_schedule? ? 1 : 5

    Array(statement_fragments[command_position..-1]).join(" ")
  end
  private :command

  def cron_attributes
    if special_schedule?
      {
        schedule_keyword: statement_fragments[0],
        command: command,
      }
    else
      {
        minute: statement_fragments[0],
        hour: statement_fragments[1],
        day_of_month: statement_fragments[2],
        month: statement_fragments[3],
        day_of_week: statement_fragments[4],
        command: command,
      }
    end
  end
  private :cron_attributes

  Error = Class.new(StandardError)
  InvalidStatement = Class.new(Error)
  MissingStatement = Class.new(Error)
end
