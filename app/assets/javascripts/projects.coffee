# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
   
jQuery ->
  $('#calendar_btn').click ->
  alert 'Handler for .click() called.'

datepickup = () ->
  $('#project_datedebut').datepicker({ dateFormat: 'dd/mm/yy' }) if $("#project_datedebut").length > 0
  $('#project_datefin').datepicker({ dateFormat: 'dd/mm/yy' }) if $("#project_datefin").length > 0
  
$(document).ready(datepickup) 
$(document).on('page:load',datepickup)


trigger_calendar = ->
  $('#calendar').fullCalendar
    header:
      left: 'prev,next today'
      center: 'title'
      right: 'month,agendaWeek,agendaDay'
    defaultView: 'month'
    height: 500
    slotMinutes: 15
    events: '/projects/index'
    timeFormat: 'h:mm t{ - h:mm t} '
    dragOpacity: '0.5'
    dayClick: ->
      alert 'a day has been clicked!'
      return
  return

functions = ->
    datepickup
    trigger_calendar
    
$(document).ready(functions) 
$(document).on('page:load',functions)