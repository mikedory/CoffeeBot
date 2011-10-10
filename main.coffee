### Set it up ###

# run as coffee -w main.coffee {"user_token":"[token]"}

# require stuff!
express	= require 'express'
http: require 'express/http'

# app settings
app	= express.createServer(
  express.logger()
  , express.bodyParser()
)
log = console.log

# command line args
arguments = process.argv.splice(2)
user_token = arguments["user_token"]

# setup
app.configure(() ->
  app.set 'views', "#{__dirname}/static/views"
  app.set 'view engine', 'jade'
)


### - APP LOGIC - ###

# root '/' (GET)
app.get '/', (req, res, user_token) ->
  res.writeHeader 200, "Content-Type": "text/plain"
  response = gettify('coffee', user_token)
  res.write response
  res.end()

	# res.render 'index.jade',
	# 	locals:
	# 		title: 'Home'

# actions '/action/' (GET)
app.get '/action/:action', (req, res, user_token) ->
    res.writeHeader 200, "Content-Type": "text/plain"
    text = JSON.stringify message: {text:"It is time to #{req.params.action}"}
    postify(text, user_token)
    res.write(text)
    res.end()

# the action of getting messages
gettify = (text, user_token) ->
  # campfireRoom = 'doryexmachina.campfirenow.com/room/443472/'
  campfireRoom = 'doryexmachina.campfirenow.com/'
  campfireURL = 'https://#{user_token}:X@#{campfireRoom}search/#{text}.json'
  http.get(campfireURL, (err, content, response) =>
    if err throw err
    r = ''
    for m in JSON.parse(content).results
      r = r + m.text + "<br />"
    this.contentType 'text/json'
    this.respond(200, r)


# the action of posting a message
postify = (text, user_token) ->
  campfireRoom = 'doryexmachina.campfirenow.com/room/443472/'
  campfireURL = 'https://#{user_token}:X@#{campfireRoom}speak.json'
  http.get(campfireURL, (err, content, response) =>
    if err throw err
    r = ''
    for m in JSON.parse(content).results
      r = r + m.text + "<br />"
    this.contentType 'text/json'
    this.respond(200, r)



### - RUN DAT APP - ###

#Listen on port 3000
app.listen 3000
console.log "Express server listening on port %d", app.address().port
