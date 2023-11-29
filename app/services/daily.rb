module Daily
  def self.quote
    quote_of_the_day = Quote.where(last_quote_of_the_day_at: DateTime.now.beginning_of_day..DateTime.now.end_of_day).first
    quote_of_the_day ||= Daily.pick_new_quote
  end

  private

  def self.pick_new_quote
    quote_of_the_day ||= Quote.eligible_for_quote_of_the_day.sample
    quote_of_the_day ||= Quote.order(last_quote_of_the_day_at: :desc).first
    
    quote_of_the_day&.update(last_quote_of_the_day_at: DateTime.now)
    quote_of_the_day
  end

  module Person
    def self.for(user)
      person_of_the_day = user.people.where(last_person_of_the_day_at: DateTime.now.beginning_of_day..DateTime.now.end_of_day).first
      person_of_the_day ||= self.roll_for(user)
    end
  
    private

    def self.roll_for(user)
      person_of_the_day ||= user.people.eligible_for_person_of_the_day.sample
      person_of_the_day ||= user.people.order(last_person_of_the_day_at: :desc).first

      person_of_the_day&.update(last_person_of_the_day_at: DateTime.now)
      person_of_the_day
    end
  end

  
end