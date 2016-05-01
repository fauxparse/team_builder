#= require jquery
#= require jquery_ujs
#= require mithril
#= require mithril_ujs
#= require mithril-touch
#= require moment
#= require moment-timezone
#= require tzdetect
#= require transit
#= require mousewheel
#= require throttle
#= require autosize.min
#= require tether
#= require drop

#= require i18n

#= require_self
#= require_tree ./lib
#= require cable

#= require models
#= require components
#= require routes

@App =
  Channels: {}
