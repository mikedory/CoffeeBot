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
	console.log opts

	request = https.request opts, (response) ->

		data = ""
		response.on "data", (chunk) ->
			data += chunk

		response.on "end", ->
			body = ""
			console.log 'log message: ' + JSON.decode(data)

			coffeeFound = data.indexOf 'coffee'

			if coffeeFound isnt -1
				body = 'we have coffee!'
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
