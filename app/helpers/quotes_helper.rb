module QuotesHelper
  def formatted_quote_explanation(quote)
    quote.description.split("\n").map do |line|
      "<p>#{CGI.escapeHTML(line)}</p>" unless line.strip.empty?
    end.join
  end
end
