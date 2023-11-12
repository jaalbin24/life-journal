module Quoterator
  # Accepts a string (the quote is the string)
  def self.generate_description(quote)
    messages = [
      {
        role: "system",
        content: [
          "You are a quote explainer.",
          "You provide a detailed explanation of the quote given by the user and describe how it can be applied in the user's life.",
          "Escape double quotes with a backslash.",
          "Do not use single quotes.",
          "Do not waste tokens by repeating the quote. Refer to the quote as \"this quote\" if it is necessary to refer to the quote."
        ].join(" ")
      },
      {
        role: "user",
        content: quote
      }
    ]
    begin
      response = OpenAi::Chat.create messages
    rescue => e
      sleep 120
      puts "#{e}\nTrying again in 120 seconds..."
      response = Quoterator.generate_description quote # Try it again recursively
    end
    response
  end

  def self.generate_all_descriptions
    filename = Rails.root.join('db/seed_data/quotes.json')
    quotes = JSON.parse(File.read(filename))
    quotes_needing_a_description = quotes.reject { |quote| !quote['description'].blank?}
    new_quotes = quotes - quotes_needing_a_description
    quotes_needing_a_description.each_with_index do |quote, i|
      unless quote['description'].blank?
        puts "(#{i + 1}/#{quotes_needing_a_description.length}) Skipping because it has a description already"
        next
      end
      puts "(#{i + 1}/#{quotes_needing_a_description.length}) Generating description for \"#{quote['body']}\"..."
      quote['description'] = generate_description(quote['body'])
      new_quotes.push quote
      File.open(Rails.root.join('db/seed_data/quotes_new.json'), "w") do |file|
        file.write(JSON.pretty_generate(new_quotes))
      end
    end
  end

  def self.rebuild_quotes
    # Get rid of all the preexisting quotes
    puts "Destroying #{Quote.count} quotes before rebuilding again..."
    Quote.all.each { |quote| quote.destroy }

    # Then recreate them from the JSON file.
    quotes = JSON.parse(File.read(Rails.root.join('db/seed_data/quotes.json')))
    puts "Rebuilding #{quotes.length} quotes..."
    quotes.each do |q|
      Quote.create(
        content: q['body'],
        author: (q['author'] unless q['author'].blank?),
        source: (q['source'] unless q['source'].blank?),
        description: (q['description'] unless q['description'].blank?)
      )
    end
    puts "Done. Rebuilt #{Quote.count} quotes."
  end
end