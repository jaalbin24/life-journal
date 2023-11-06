class AddLastQuoteOfTheDayAtToQuotes < ActiveRecord::Migration[7.0]
  def change
    add_column :quotes, :last_quote_of_the_day_at, :datetime
  end
end
