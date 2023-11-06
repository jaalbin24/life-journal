class ChatsController < ApplicationController
  before_action :redirect_unauthenticated
  before_action :set_entry

  def create
    respond_to do |format|
      @chat = @entry.chats.build
      if @chat.save
        alerts_now.append Alert::Info.new(title: "Chat created").flash
        format.turbo_stream do
          @message = @chat.messages.build
          @messages = @chat.messages.excluding(@message)
          render turbo_stream:  turbo_stream.replace(:chat, partial: 'messages/index') + 
                                turbo_stream.replace(:message_form, partial: 'messages/form')
        end
      else
        alerts_now.append Alert::Error.new(title: "Chat not created").flash
        format.turbo_stream do
          @messages = @chat.messages
          render turbo_stream:  turbo_stream.replace(:chat, partial: 'chats/new')
        end
      end
      
    end
  end

  private

  def set_entry
    @entry = current_user.entries.find(params[:entry_id])
  end
end
