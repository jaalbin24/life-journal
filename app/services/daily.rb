module Daily
  def self.quote
    quote_of_the_day = Quote.where(last_quote_of_the_day_at: DateTime.now.beginning_of_day..DateTime.now.end_of_day).first
    quote_of_the_day ||= Daily.pick_new_quote
  end

  def self.pick_new_quote
    quote_of_the_day ||= Quote.eligible_for_quote_of_the_day.sample
    quote_of_the_day ||= Quote.order(last_quote_of_the_day_at: :desc).first
    quote_of_the_day&.update(last_quote_of_the_day_at: DateTime.now)
    quote_of_the_day
  end
end