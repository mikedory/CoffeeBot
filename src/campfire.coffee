http = require "http"
https = require "https"
encode = require('base64').encode

exports.Campfire = Campfire = (options, callback) ->
	opts = 
		host: options.host
		path: options.path
		method: options.method
		userToken: options.userToken
		authorization: 'Basic ' + encode("#{options.userToken}" + ':x')
		headers: {
			'Authorization' : 'Basic ' + encode("#{options.userToken}" + ':x')
			'Host' : options.host
			'Content-Type' : 'application/json'
		}

	request = https.request opts, (response) ->

		data = ""
		response.on "data", (chunk) ->
			data += chunk

		response.on "end", ->
			body = ""
			# console.log "log message: #{data}"

			# set up the routes
			# coffeeFound = data.indexOf 'coffee'

			# find the last message
			messages = JSON.parse(data).messages
			message = messages[0]
			coffeeFound = message.body.indexOf 'coffee'

			# make the time work-with-able
			time = new Date message.created_at

			if coffeeFound isnt -1
				body = "Coffee was requested at #{time}!"
			else
				body = null

			if not body
				callback "wah. nothing."
			else
				callback null, body

		response.on "error", (error) ->
			callback error

	request.on "error", (error) ->
		callback error

	request.end()
