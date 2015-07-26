# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

refresh_users = -> 
        setTimeout(updateusers, 5000) if $('#users').length > 0
        
        
updateusers = () ->
              $.getScript('/users') if $('#users').length > 0
              setTimeout(updateusers, 5000) if $('#users').length > 0
              
$(document).ready(refresh_users) 
$(document).on('page:load',refresh_users)
        
        

    
