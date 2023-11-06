class MessagesController < ApplicationController
  before_action :redirect_unauthenticated
  before_action :set_chat

  def create
    respond_to do |format|
      @message = @chat.messages.build(message_params)
      if @message.save
        format.turbo_stream do
          render turbo_stream:  turbo_stream.append(:message_collection, partial: 'messages/member') +
                                turbo_stream.replace(:message_form, partial: 'messages/form')
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
