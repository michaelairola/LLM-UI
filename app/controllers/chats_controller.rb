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
    @input = chat_params[:input]
    @chat = Chat.new(name: @input, user: Current.user)
    @chat.messages = [ 
      Message.new(role: Message.roles[:user], value: @input),
      Message.new(role: Message.roles[:assistant], value: "No AI response yet! will set that up next...") 
    ]
    if @chat.save
      redirect_to @chat
    else
      puts @chat.errors.full_messages
      @chats = Chat.where(user: Current.user)      
      @examples = get_chat_examples()
      render :show, status: :unprocessable_entity
    end    
  end

  def update
    @input = chat_params[:input]
    @chat = Chat.find(params[:id])
    @chat.messages = @chat.messages.concat([ 
      Message.new(role: Message.roles[:user], value: @input),
      Message.new(role: Message.roles[:assistant], value: "No AI response yet! will set that up next...") 
    ])
    if @chat.save
      redirect_to @chat
    else
      puts @chat.errors.full_messages
      @chats = Chat.where(user: Current.user)      
      @examples = get_chat_examples()
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
  end

  private
    def chat_params
      params.expect(chat: [ :input ])
    end

end
