isup = require "./isitup.coffee"

url = 'http://google.com'

isup.isItUp url, (err, msg) ->
  if err or not msg
    console.log err
  else
    console.log msg