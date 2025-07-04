class ChatsController < ApplicationController
  include ChatsHelper
  before_action :set_chat, only: %i[ show update destroy ]
  before_action :set_chats, only: %i[ show new ]
  before_action :set_input, only: %i[ create update ]
  before_action :set_examples, only: %i[ new ]
  
  def new
    @chat = Chat.new
    render :show
  end
  
  def show
  end

  def create
    @chat = Chat.new(name: @input, user: Current.user)
    @chat.messages = [
      Message.new(role: Message.roles[:user], value: @input),
      Message.new(role: Message.roles[:assistant], value: "No AI response yet! will set that up next...") 
    ]
    save_chat
  end

  def update
    @chat.touch
    @chat.messages = @chat.messages.concat([ 
      Message.new(role: Message.roles[:user], value: @input),
      Message.new(role: Message.roles[:assistant], value: "No AI response yet! will set that up next...") 
    ])
    save_chat
  end

  def destroy
    @chat.destroy
    redirect_back_or_to root_path
  end

  private
    def set_input
      @input = params.expect(chat: [ :input ])[:input]
    end
    
    def set_chat
      @chat = Chat.find(params[:id])
    end
    
    def set_chats
      @chats = Chat.where(user: Current.user).order("updated_at desc")
    end    
    
    def set_examples
      @examples = get_chat_examples()
    end
    
    def save_chat 
      if @chat.save
        redirect_to @chat
      else
        puts @chat.errors.full_messages
        set_chats
        set_examples
        render :show, status: :unprocessable_entity
      end
    end
end
