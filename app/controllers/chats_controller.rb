class ChatsController < ApplicationController
  def new
    @chat = Chat.new
    render :show
  end
  
  def show
    Chat.find(params[:id])
  end
  
  def index
    @chats = Chat.where(user: Current.user)
    render json: @chats
  end

  def create
  end

  def update
  end

  def destroy
  end
end
