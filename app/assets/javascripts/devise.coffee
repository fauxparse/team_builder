#= require jquery
#= require jquery_ujs
#= require_self

$ ->
  $("input")
    .on "input", ->
      $(this).closest(".field").toggleClass("has-value", !!$(this).val())
