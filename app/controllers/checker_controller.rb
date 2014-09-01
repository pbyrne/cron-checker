class CheckerController < ApplicationController
  def index
  end

  def show
    @cron_parser = CronParser.new(params[:statement])
    @cron = @cron_parser.cron
  rescue CronParser::Error
    flash[:error] = @cron_parser.error_message
    redirect_to root_path(statement: params[:statement])
  end
end
