# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

refresh_users = -> 
        setTimeout(update_users, 5000) if $('#users').length > 0
        setTimeout(update_user_contacts, 5000) if $('#user_contacts').length > 0
        setTimeout(update_users_sidemenu, 5000)
        
        
update_users = () ->
              $.getScript('/users') if $('#users').length > 0
              setTimeout(updateusers, 5000) if $('#users').length > 0
              
update_user_contacts = () -> 
              $.getScript('/users/contacts_utilisateur') if $('#user_contacts').length > 0
              setTimeout(update_user_contacts, 5000) if $('#user_contacts').length > 0
              
update_users_sidemenu = () ->
              $.getScript('/contacts_utilisateur?sidemenu=true')
              setTimeout(updateusers_sidemenu, 5000)            
              
$(document).ready(refresh_users) 
$(document).on('page:load',refresh_users)
        
        

    
