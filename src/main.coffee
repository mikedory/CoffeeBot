### Set it up ###

# run as coffee -w main.coffee {\"userToken\":\"[token]\"}

# require stuff!
express = require 'express'
http = require 'http'
https = require 'https'

# include libs
campfire = require "./campfire.coffee"
isup = require "./examples/isitup.coffee"

# app settings
app = express.createServer()
log = console.log

# command line args
arguments = process.argv.splice(2)
json = JSON.parse(arguments)


# userToken = arguments["userToken"]
userToken = json["userToken"]
campfireRoom = "doryexmachina.campfirenow.com"

# setu up the app variables
app.configure(() ->
  app.set 'views', "#{__dirname}/static/views"
  app.set 'view engine', 'jade'
)


### - APP ROUTES - ###

# root '/' (GET)
app.get '/', (req, res) ->
  console.log req.method, req.url
  # key = req.url[1...]
  contentType = 'text/plain'
  code = 200
  value = "#{req.method} | #{req.url}\n"
  respond res, code, contentType, value + '\n'


# search '/search/' (GET)
app.get '/search/:term', (req, res) ->
  console.log req.method, req.url
  # key = req.url[1...]
  contentType = 'text/plain'
  code = 404

  try 
    if not req.params.term
      value = 'no term =('
      respond res, code, contentType, value + '\n'
    else
      campcall = campfireSearch(req.params.term)
      # write it out
      if (campcall)
        code = 200
        value = 'yay!'
        respond res, code, contentType, value + '\n'
      else 
        value = 'boo.'
        respond res, code, contentType, value + '\n'
  catch error
    value = error



# check to see if a site is up (thanks to Pickle!)
app.get '/isitup/:url', (req, res) ->
  console.log req.method, req.url
  key = req.url[1...]
  contentType = 'text/plain'
  code = 404


  message = isup.isItUp req.params.url, (err, msg) ->
    if err or not msg
      code = 400
      value = err
      respond res, code, contentType, value + '\n'
    else
      code = 200
      value = msg
      respond res, code, contentType, value + '\n'
  

### - action stuff! - ###

# get something
campfireSearch = (text, last = "") ->
  
  # set it up
  options =
    host: "doryexmachina.campfirenow.com"
    path: "/search/coffee.json"
    method: 'GET'
    userToken: userToken

  # make the call
  campfire.Campfire options, (err, msg) ->
    if err or not msg
      log("ERRORZ: #{err}")
    else
      log("#{text} and #{msg}")
    return msg

  call = 'yerp'
  log "campcall: #{call}"
  return call


# helper function that responds to the client
respond = (res, code, contentType, data) ->
    res.writeHead code,
        'Content-Type': contentType
        'Content-Length': data.length
    res.write data
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
