mongoose = require "mongoose"
express = require "express"
route = require "./route"
http = require "http"
path = require "path"
app = express()
app.configure ->
  app.set "port", process.env.PORT or 3000
  app.set "host", process.env.IP or "localhost"
  app.set "views", __dirname + "/view"
  app.set "view engine", "jade"
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express["static"](__dirname + "/public")

app.configure "development", ->
  mongoose.connect 'mongodb://sto_user:reverse@linus.mongohq.com:10083/mdb'
  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )

app.configure "production", ->
  mongoose.connect 'mongodb://sto_user:reverse@linus.mongohq.com:10083/mdb-prod'
  app.use express.errorHandler()
    
app.get  "/", route.index
app.get  "/index", route.index
app.get  "/add_tag", route.add_tag
app.post "/tag/new", route.addTag


http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")
