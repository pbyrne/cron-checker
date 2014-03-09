module CheckerHelper
  def link_to_cron(statement)
    link_to statement, check_path(statement: statement)
  end
end
