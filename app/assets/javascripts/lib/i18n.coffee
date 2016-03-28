I18n.dateRange = (startDate, endDate) ->
  if !endDate
    I18n.t("moment.range.from", date: startDate.format(I18n.t("moment.short")))
  else
    key = if startDate.isSame(endDate, "day")
      "same_day"
    else if startDate.isSame(endDate, "month")
      "same_month"
    else if startDate.isSame(endDate, "year")
      "same_year"
    else
      "different"
    I18n.t("moment.range.#{key}",
      d1: startDate.date()
      d2: endDate.date()
      m1: startDate.format("MMM")
      m2: endDate.format("MMM")
      y1: startDate.year()
      y2: endDate.year()
    )
