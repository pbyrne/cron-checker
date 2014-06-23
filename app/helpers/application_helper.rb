module ApplicationHelper
  def copyright(start_year)
    notice = content_tag(:abbr, "©", title: "copyright")
    year =
      if start_year == Date.today.year
        start_year
      else
        "#{start_year}–#{Date.today.year}"
      end

    "#{notice} #{year}".html_safe
  end
end
