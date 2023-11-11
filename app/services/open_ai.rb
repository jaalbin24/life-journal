module OpenAi
  module Chat
    def self.create(messages, options={stream: true, max_tokens: 1000})
    raise OpenAi::Error.new "Messages must be an array of hashes, not #{messages.class}" unless messages.is_a? Array
    raise OpenAi::Error.new "Cannot send blank message to API" if  messages.blank?
    messages.each { |m| raise OpenAi::Error.new "Messages can only contain hashes" unless m.is_a? Hash }

    uri = URI('https://api.openai.com/v1/chat/completions')
      
      request = Net::HTTP::Post.new(uri)
      request["Content-Type"] = "application/json"
      request["Authorization"] = "Bearer #{ENV['OPENAI_API_KEY']}"
      request.body = JSON.dump({
        model: "gpt-3.5-turbo",
        messages: messages,
        # [
        #   {
        #     role: "system",
        #     content: "You are a helpful assistant."
        #   },
        #   {
        #     role: "user",
        #     content: "Hello!"
        #   }
        # ],
        max_tokens: options[:max_tokens],
        stream: options[:stream]
      })
      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
        http.request(request) do |response|
          buffer = ""
          response.read_body do |chunk|
            puts "chunk: #{chunk}"
            buffer << chunk
            while line = buffer.slice!(/.*\n/) # Extract line by line from buffer
              line.strip! # Remove any extraneous whitespace
              next unless line.start_with?('data:') # We're only interested in lines that start with 'data:'

              json = line.sub('data: ', '') # Remove the 'data: ' prefix

              begin
                parsed_json = JSON.parse(json) # Now parse the JSON
                yield parsed_json['choices'][0]['delta']['content'] if block_given?
                puts "Received JSON: #{parsed_json}"
              rescue JSON::ParserError => e
                puts "JSON parsing error: #{e.message}"
              end
            end
            
          end
        end
      end
      puts "🔥 response ====> #{response}"
      puts "🔥 response.body ====>#{response.body}"
    end
  end

  class Error < StandardError
  end
end