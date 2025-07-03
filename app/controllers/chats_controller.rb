class ChatsController < ApplicationController
  include ChatsHelper
  def new
    @chat = Chat.new
    @chats = Chat.where(user: Current.user)
    @examples = get_chat_examples()
    render :show
  end
  
  def show
    @chat = Chat.find(params[:id])
    @chats = Chat.where(user: Current.user).where.not(id: @chat.id)
  end

  def create
  end

  def update
  end

  def destroy
  end
end
