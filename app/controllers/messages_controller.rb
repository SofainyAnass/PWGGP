class MessagesController < ApplicationController
  
  def new
    
      @user = User.find(params[:user])
      
      @message=  Message.new
      
      @messages = Message.messages_partages(current_user,@user,Time.at(params[:after].to_i + 1))
      
      @titre = "Nouveau message pour #{@user.contact.nom_complet}"
    
  end
  
  def create
      
    @user = User.find(params[:user])
    
    @message=current_user.nouveau_message!(@user, params[:message][:content])
    
    message = Clientxmpp.send_message(Clientxmpp.user_xmpp_name(@user),@message.content)
       
    
    
  end
  
  def update
    
    
  end
  
  def index
    
  end
  
  def delete
    
  end
  
  def destroy
    
  end
  
    
  
  
end
