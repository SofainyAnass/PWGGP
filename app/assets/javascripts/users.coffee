# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

refresh_users = -> 
        setTimeout(update_users, 5000) if $('#users').length > 0
        setTimeout(update_user_followings, 5000) if $('#user_followings').length > 0
        setTimeout(update_users_sidemenu, 5000)  if $('#users_sidemenu').length > 0
        
        
update_users = () ->
              $.getScript('/users') if $('#users').length > 0
              setTimeout(update_users, 5000) if $('#users').length > 0
              
update_user_followings = () -> 
              user_id = $('#users_sidemenu').attr('data-user') if $('#user_followings').length > 0
              $.getScript('/users/'+user_id+'/following') if $('#user_followings').length > 0
              setTimeout(update_user_followings, 5000) if $('#user_followings').length > 0
              
update_users_sidemenu = () ->
              user_id = $('#users_sidemenu').attr('data-user')
              $.getScript('/users/'+user_id+'/following?sidemenu=true')
              setTimeout(update_users_sidemenu, 5000)            
              
$(document).ready(refresh_users) 
$(document).on('page:load',refresh_users)
        
        

    
