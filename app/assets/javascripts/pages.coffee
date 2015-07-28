# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/



trigger_calendar = ->
  $('#calendar').fullCalendar
    header:
      left: 'prev,next today'
      center: 'title'
      right: 'month,agendaWeek,agendaDay'
    defaultView: 'month'
    height: 500
    slotMinutes: 15
    events: '/users/get_events'
    timeFormat: 'h:mm t{ - h:mm t} '
    dragOpacity: '0.5'
    dayClick: ->
      alert 'a day has been clicked!'
      return
  return



$(document).ready(trigger_calendar) 
$(document).on('page:load',trigger_calendar)