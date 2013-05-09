http = require "http"
https = require "https"
fs = require "fs"
crypto = require "crypto"
qs = require "querystring"
url = require "url"

cheerio = require "cheerio"
express = require "express"
app = express()

if process.argv[2] is "-p"
	PORT = parseInt process.argv[3]
else
	PORT = 1333
app.set "port", PORT.toString()
app.configure ->
	app.use express.bodyParser()
app.use "/css", express.static "css"
app.use "/js", express.static "js"

app.all "/", (request, response) ->
	response.send "Hello World"

app.use (req, res, next) ->
  res.send 404, "Sorry cant find that!"
app.listen PORT, ->
	console.log "Ze Proxy is listening on port #{PORT}"