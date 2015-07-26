# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


refresh_messages = -> 
        $('#messages').scrollTop($('.message').length*$('.message').height()) if $('#messages').length > 0
        setTimeout(updatemessages, 5000) if $('#messages').length > 0
        
        
updatemessages = () ->
              user_id = $('#messages').attr('data-user') if $('#messages').length > 0
              after = $('.message:last').attr('data-time') if $('#messages').length > 0
              $.getScript('/messages/new.js?user=' + user_id + "&after=" + after) if $('#messages').length > 0              
              setTimeout(updatemessages, 5000) if $('#messages').length > 0
                                          
$(document).ready(refresh_messages)
$(document).on('page:load',refresh_messages)


