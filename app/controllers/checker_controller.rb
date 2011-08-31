class CheckerController < ApplicationController
  def index
  end

  def check
    @cron = Cron.new(params[:statement])
  end

end
