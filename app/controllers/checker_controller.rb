class CheckerController < ApplicationController
  def index
  end

  def show
    @cron = CronParser.new(params[:statement]).cron
  rescue CronParser::InvalidStatement
    flash[:error] = "Unrecognized cron statement '#{params[:statement]}'."
    redirect_to root_path(statement: params[:statement])
  rescue CronParser::MissingStatement
    flash[:error] = "You must provide a cron statement."
    redirect_to root_path
  end
end
