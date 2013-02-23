
express = require("express")
route = require("./route")
http = require("http")
path = require("path")
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
    app.use express.errorHandler(
      dumpExceptions: true
      showStack: true
    )
    
app.get "/", route.index
app.get  "/add_item", route.add_item

http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")

