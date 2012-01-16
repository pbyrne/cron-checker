module CheckerHelper
  def link_to_cron(statement)
    link_to(statement, checker_url(:statement => statement))
  end
end
