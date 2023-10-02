module DaysHelper
  def timeline
    today = Date.today
    if today.sunday?
      last_sunday = today
    else
      last_sunday = today - today.wday
    end
    first_day = last_sunday - 1.year
    entries_in_the_last_year = User.first.entries.where(published_at: first_day.beginning_of_day..today.end_of_day).to_a
    calendar = {}
    (0..((today - first_day).to_i - 1)).to_a.reverse.each do |days_ago|
      date = today - days_ago.days
      calendar[date] = entries_in_the_last_year.select { |entry| entry.published_at.to_date == date }
    end
    calendar
  end
end
