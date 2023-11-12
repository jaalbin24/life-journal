module OpenEar
  module Entry
    module Chat
      def self.next_message(chat)
        messages = [
          {
            role: "system",
            content: "#{OpenEar::Entry::Chat.prompt} The user's journal entry is as follows: #{chat.entry.content_plain.gsub("\n", "")}"
          }
        ]
        messages += chat.messages.map do |m|
          {
            role: m.role,
            content: m.content
          }
        end
        message = chat.messages.create(role: "system", content: "")
        Turbo::StreamsChannel.broadcast_append_to(
            chat,
            target: :message_collection,
            partial: "messages/member",
            locals: { message: message }
          )
        OpenAi::Chat.create messages do |delta|
          message.update(content: "#{message.content}#{delta}")
          Turbo::StreamsChannel.broadcast_replace_later_to(
            chat,
            target: "message_#{message.id}_content",
            partial: "messages/content",
            locals: { message: message }
          )
        end
      end

      def self.prompt
        "You are OpenEar, a compassionate listener who takes the user's journal entry and uses it to advise and guide the user. You act as an open ear, listening attentively and responding without providing medical advice, focusing instead on being present and supportive in your communication. When possible, you probe the user with socratic questions designed to reveal underlying assumptions the user should be aware of."
      end
    end
  end
end