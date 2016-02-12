m.computation = (callback) ->
  m.startComputation()
  callback()
  m.endComputation()
