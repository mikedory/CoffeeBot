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


### - APP ROUTES - ###

# root '/' (GET)
app.get '/search/:term', (req, res) ->
  campcall = campfireSearch(req.params.term)
  # write it out
  if (campcall)
    res.writeHeader 200, "Content-Type": "text/plain"
    res.end "yay!\n"
  else 
    res.writeHeader 400, "Content-Type": "text/plain"
    res.end "boo.\n"

# check to see if a site is up (thanks to Pickle!)
app.get '/isitup/:url', (req, res) ->
  message = isup.isItUp req.params.url, (err, msg) ->
    if err or not msg
      res.writeHeader 400, "Content-Type": "text/plain"
      log err
      res.end "#{err}\n"
    else
      res.writeHeader 200, "Content-Type": "text/plain"
      log msg
      res.end "#{msg}\n"
  
  # res.writeHeader 200, "Content-Type": "text/plain"
  # res.end




### - action stuff! - ###

# get something
campfireSearch = (text) ->
  
  # set it up
  options =
    host: "doryexmachina.campfirenow.com"
    path: "/search/coffee.json"
    method: 'GET'
    userToken: userToken

  # make the call
  campcall = campfire.Campfire options, (err, msg) ->
    if err or not msg
      log 'ERRORZ:'
      log err
    else
      # log msg
      log("#{text} and #{msg}")
      return msg
    log msg
    log 'oi'
    return msg
  return campcall





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
