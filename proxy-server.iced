http = require "http"
https = require "https"
fs = require "fs"
crypto = require "crypto"
qs = require "querystring"
urllib = require "url"
zlib = require "zlib"
Transform = require('stream').Transform

cheerio = require "cheerio"
express = require "express"
request = require "request"

uppercase = new Transform {decodeStrings: false}
uppercase._transform = (chunk, encoding, done) ->
	done null, chunk.toUpperCase()

app = express()

if process.argv[2] is "-p"
	PORT = parseInt process.argv[3]
else
	PORT = 1333
app.set "port", PORT.toString()
#app.configure ->
	#app.use express.bodyParser()
app.use "/css", express.static "css"
app.use "/js", express.static "js"

# HTTP URLs
app.all /^\/serve\/http\/[a-zA-Z]{1}([\w\-]+\.)+([\w]{2,5}).*/, (req, res) ->
	#method = req.method
	#headers = req.headers
	url = req.url.split("/serve/http/").join ""
	url = "http://" + url
	url = decodeURIComponent url
	console.log "Requested URL is #{url}"
	
	headers = req.headers
	headers["accept-encoding"] = ""
	#return res.send JSON.stringify req.headers

	requestedPage = request {"uri": url, "headers": headers, "method": req.method} #"encoding": "utf-8"

	###
	STUFF = ""
	requestedPage.on "data", (stuff) ->
		STUFF += stuff
	requestedPage.on "end", ->
		STUFF = new Buffer(STUFF)
		zlib.gunzip STUFF, (daata) ->
			res.send(daata + "{}Hi")
	###
	requestedPage.pipe(res)
# HTTPS URLs


app.get "/", (req, res) ->
	fs.readFile "index.html", {"encoding": "utf-8"}, (err, data) ->
		$ = cheerio.load data
		$("#year").text(new Date().getFullYear());
		res.send $.html()

app.use (req, res, next) ->
	fs.readFile "404.html", {"encoding": "utf-8"}, (err, data) ->
		res.send 404, data
app.listen PORT, ->
	console.log "Ze Proxy is listening on port #{PORT}"