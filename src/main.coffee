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
  campcall = campfire.Campfire {
    host: "doryexmachina.campfirenow.com"
    path: "/search/coffee.json"
    method: 'GET'
    userToken: userToken
  }, (err, msg) ->
    if err or not msg
      log 'ERRORZ:'
      log err
    else
      # log msg
      gettify(text, msg)

  # write it out
  if (campcall)
    res.writeHeader 200, "Content-Type": "text/plain"
    res.end "yay!\n"
  else 
    res.writeHeader 500, "Content-Type": "text/plain"
    res.end "boo.\n"

# check to see if a site is up (thanks to Pickle!)
app.get '/isitup/:url', (req, res) ->
  isup.isItUp req.params.url, (err, msg) ->
    if err or not msg
      log err
    else
      log msg
  
  res.writeHeader 200, "Content-Type": "text/plain"
  res.end

gettify = (text, msg) ->
  log "Whilst searching for #{text} I found: '#{msg}'"


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
