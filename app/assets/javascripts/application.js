// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui/autocomplete
//= require autocomplete-rails
//= require turbolinks
//= require moment
//= require fullcalendar
//= require_tree .



$(document).ready(function() {
	
   $("#calendar").fullCalendar({
     header: { left: "prev,next today", center: "title", right: "month,agendaWeek,agendaDay" },
     defaultView: "month",
     height: 500,
     slotMinutes: 15,
     events: "/users/get_events",
     timeFormat: "h:mm t{ - h:mm t} ",
     dragOpacity: "0.5",
     
     dayClick: function() {
       alert('a day has been clicked!');
   	 }	 
   
  });

   
});
   
$(function () {
  if ($('#users').length > 0) {	  
    setTimeout(updateusers, 5000);
  }
});

function updateusers() {
	$.getScript('/users');
	setTimeout(updateusers, 5000);
}

$(function () {
  if ($('#messages').length > 0) {	  
    setTimeout(updatemessages, 5000);
  }
});

function updatemessages() {
	var user_id = $('#messages').attr('data-user');
	var after = $('.message:last').attr('data-time');
	$.getScript('/messages/new.js?user=' + user_id + "&after=" + after);
	setTimeout(updatemessages, 5000);
}

