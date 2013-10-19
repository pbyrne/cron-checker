class CheckerController < ApplicationController
  def index
  end

  def show
    if params[:statement].present?
      @cron = Cron.new(params[:statement])
    else
      flash[:error] = "You must provide a cron statement."
      redirect_to root_path
    end
  end
end
