class MessagesController < ApplicationController
  
    before_filter :verify_connection
    before_filter :not_idle, :except => [:new]
    
    
    def index
    
    @message=  Message.new
    
    @user = User.find(params[:id])
    
    @messages = Hash.new
    
    @users = @user.contacts_utilisateur
    
    @users.each do |user|
      
       @messages[user]=Message.messages_partages(current_user,user)
      
    end
 
      
    @titre = "Mes messages"
    
    
  end
  
  def new
    
      @user = User.find(params[:user])
      
      @message=  Message.new
      
      @messages = Message.messages_partages(current_user,@user,Time.at(params[:after].to_i + 1))
      
      @titre = "Nouveau message pour #{@user.contact.nom_complet}"
    
  end
  
  def create
      
      
    @user = User.find(params[:user])
        
    @message=current_user.nouveau_message!(@user, params[:message][:content])
    
    
    Clientxmpp.send_message(@current_user,Clientxmpp.user_xmpp_name(@user),@message.content)
       
    
    
  end
  
  def update
    
    
  end
  
  
  
  def delete
    
  end
  
  def destroy
    
  end
  
   def show
    
  end
  
    
  
  
end
