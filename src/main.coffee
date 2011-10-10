### Set it up ###

# run as coffee -w main.coffee {"userToken":"[token]"}
# actually, for now, run as coffee -w main.coffee [token]

# require stuff!
express = require 'express'
http = require 'http'
https = require 'https'

# include libs
campfire = require "./campfire.coffee"
isup = require "./examples/isitup.coffee"

# app settings
app = express.createServer(
  express.logger()
  , express.bodyParser()
)
log = console.log

# command line args
arguments = process.argv.splice(2)
# userToken = arguments["userToken"]
userToken = arguments[0]
campfireRoom = "doryexmachina.campfirenow.com"

# setup
app.configure(() ->
  app.set 'views', "#{__dirname}/static/views"
  app.set 'view engine', 'jade'
)


### - APP LOGIC - ###

# root '/' (GET)
app.get '/', (req, res) ->

  text = 'coffee'

  campfire.Campfire {
    host: "doryexmachina.campfirenow.com"
    path: "/search/coffee.json"
    method: 'GET'
    userToken: userToken
  }, (err, msg) ->
    if err or not msg
      log 'ERRORZ:'
      log err
    else
      log 'MESSAGE:'
      log msg

  # res.writeHeader 200, "Content-Type": "text/plain"
  # response = gettify('coffee', userToken)
  # response = "<h1>hello!</h1><p>#{msg}</p>"
  # res.write res
  res.end()

# check to see if a site is up (thanks to Pickle!)
app.get '/isitup/', (req, res) ->
  isup.isItUp 'google.com', (err, msg) ->
    if err or not msg
      console.log err
    else
      console.log msg


# actions '/action/' (GET)
app.get '/action/:action', (req, res, userToken) ->
  res.writeHeader 200, "Content-Type": "text/plain"
  text = JSON.stringify message: {text:"It is time to #{req.params.action}"}
  postify(text, userToken)
  res.write(text)
  res.end()

# # the action of getting messages
# gettify = (text, userToken) ->
#   # campfireRoom = 'doryexmachina.campfirenow.com/room/443472/'
#   campfireRoom = 'doryexmachina.campfirenow.com/'
#   campfireURL = 'https://#{userToken}:X@#{campfireRoom}search/#{text}.json'
#   http.get(campfireURL, (err, content, response) =>
#     # if (err) throw err
#     r = ''
#     for m in JSON.parse(content).results
#       r = r + m.text + "<br />"
#     this.contentType 'text/json'
#     this.respond(200, r)
#   )


# # the action of posting a message
# postify = (text, userToken) ->
#   campfireRoom = 'doryexmachina.campfirenow.com/room/443472/'
#   campfireURL = 'https://#{userToken}:X@#{campfireRoom}speak.json'
#   http.get(campfireURL, (err, content, response) =>
#     # if err throw err
#     r = ''
#     for m in JSON.parse(content).results
#       r = r + m.text + "<br />"
#     this.contentType 'text/json'
#     this.respond(200, r)
#   )
#   console.log(text)



### - Run tell dat - ###

#Listen on port 3000
app.listen 3000
console.log "Express server listening on port %d", app.address().port
