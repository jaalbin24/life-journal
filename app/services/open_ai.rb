module OpenAi
  module Chat
    def self.create(messages, options={stream: false, max_tokens: 1000})
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
        http.read_timeout = 120
        http.request(request)
      end
      body = JSON.parse(response.body)
      if body["error"]

      end
      # puts "🔥 response ====> #{response}"
      # puts "🔥 response.body ====>#{response.body}"
      body["choices"][0]["message"]["content"]
    end
  end

  class Error < StandardError
  end
end