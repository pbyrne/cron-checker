class CheckerController < ApplicationController
  def index
  end

  def check
    if params[:statement].present?
      @cron = Cron.new(params[:statement])
    else
      redirect_to root_url
    end
  end
end
