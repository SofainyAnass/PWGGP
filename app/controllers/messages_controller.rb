class MessagesController < ApplicationController
  
  def new
    
      @message = Message.new
      @user = User.find(params[:user])
      @messages = Message.where(" ( ( source = (?) and destination = (?) ) and created_at > ? ) or ( ( source = (?) and destination = (?) ) and created_at > ? ) ", Clientxmpp.to_xmpp_address(@user.login), Clientxmpp.to_xmpp_address(current_user.login), Time.at(params[:after].to_i + 1), Clientxmpp.to_xmpp_address(current_user.login), Clientxmpp.to_xmpp_address(@user.login) , Time.at(params[:after].to_i + 1) )
      @titre = "Nouveau message pour #{@user.contact.nom_complet}"
    
  end
  
  def create
    
    @message = Message.new(:content => params[:message][:content])  
    @user = User.find(params[:user])
    @messages = Message.where(" ( ( source = (?) and destination = (?) ) and created_at > ? ) or ( ( source = (?) and destination = (?) ) and created_at > ? ) ", Clientxmpp.to_xmpp_address(@user.login), Clientxmpp.to_xmpp_address(current_user.login), Time.at(params[:after].to_i + 1), Clientxmpp.to_xmpp_address(current_user.login), Clientxmpp.to_xmpp_address(@user.login) , Time.at(params[:after].to_i + 1) )
    @titre = "Nouveau message pour #{@user.contact.nom_complet}" 
       
    message = Clientxmpp.send_message(@user.login,@message.content)
    Message.create!(:source=> "#{current_user.login}@destroyer/home", :destination => message.to,:content => message.body)
    
    render 'new'
    
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
