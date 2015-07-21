module SessionsHelper
  
  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user  
    @current_user.connexions.create!
  end
  
  def current_user
    @current_user ||= user_from_remember_token
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def sign_out
 
    Clientxmpp.disconnect 
    self.current_user    
    
    if(@current_user != nil)
      @current_user.connexions.first.disconnect
    end
    
    cookies.delete(:remember_token)   
    self.current_user

    respond_to do |format|
        format.html { redirect_to root_path }
        format.js  { render :js => "window.location = '/'" }
    end
     
  end
  
  def authenticate
      deny_access unless signed_in?
  end
  
  def deny_access
    store_location
    redirect_to root_path, :notice => "Veuillez vous identifier pour acceder a cette page."
  end
   
  def verify_connection
    
    if(signed_in?)
      if !Clientxmpp.is_connected?
        sign_out  
      end   
    else
      deny_access  
    end
      
  end
  
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end
  
  def current_user?(user)
    user == current_user
  end
  
  def admin_user
      redirect_to(root_path) unless current_user.admin?
  end
  
  
  private

    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end

    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end
    
    def store_location
      session[:return_to] = request.fullpath
    end

    def clear_return_to
      session[:return_to] = nil
    end
    
end
