stitch = require "stitch"
express = require "express"
app = express()

app.set "view engine", "ejs"
app.use express.static(__dirname + '/public')

app.get "/", (req, res) ->
  res.render("index")

pkg = stitch.createPackage
  paths: ["#{__dirname}/src"]
app.get "/bundle.js", pkg.createServer()

app.listen 9000
console.log "Server running at http://localhost:9000"
