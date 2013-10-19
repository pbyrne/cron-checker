class CronParser
  attr_accessor :statement

  def initialize(statement)
    self.statement = statement
  end

  # Parse a given cron statement
  #
  # statement - A String containing the cron statement to parse
  #
  # Returns a Cron instance
  def call
    @cron ||= Cron.new
  end
end
