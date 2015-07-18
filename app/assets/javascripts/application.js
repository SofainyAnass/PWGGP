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
//= require jquery-ui
//= require autocomplete-rails
//= require turbolinks
//= require_tree .

$('#contact_name').bind('railsAutocomplete.select', function(event){
  /* Do something here */
  alert("zeze");
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

