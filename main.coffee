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


client = http.createClient 80, site


### - APP LOGIC - ###

# root '/' (GET)
app.get '/', (req, res) ->
  res.writeHeader 200, "Content-Type": "text/plain"
  res.write "Hello, World!"
  res.write req.params
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

# the action of posting a message
postify = (text, user_token) ->
  campfireURL = 'https://#{user_token}:X@doryexmachina.campfirenow.com/room/443472/speak.json'
  app.post campfireURL, (req, res, campfireURL, text) ->
      # res.writeHeader "Content-Type": "text/json"
      res.send(text)
      res.send('text', { 'Content-Type': 'text/plain' });



### - RUN DAT APP - ###

#Listen on port 3000
app.listen 3000
console.log "Express server listening on port %d", app.address().port
