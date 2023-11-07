class MessagesController < ApplicationController
  before_action :redirect_unauthenticated
  before_action :set_chat

  def create
    respond_to do |format|
      @message = @chat.messages.build(message_params)
      @message.role = "user"
      if @message.save
        format.turbo_stream do
          Turbo::StreamsChannel.broadcast_append_later_to(
            @chat,
            target: :message_collection,
            partial: "messages/member",
            locals: { message: @message }
          )
          render turbo_stream:  turbo_stream.replace(:message_form, partial: 'messages/form') +
                                turbo_stream.remove(:message_reccomendations)

        end
      else
        
      end
    end
  end


  private

  def set_chat
    @chat = current_user.chats.find(params[:chat_id])
  end

  def message_params
    params.require(:message).permit(
      :content
    )
  end
end
