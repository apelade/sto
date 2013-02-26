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
# some routes commented out as unused by public or route index.coffee
# tagAdd now includes tags and tagForm
#app.get  "/tags"      , route.tags
#app.get  "/tag/form"  , route.tagForm
app.get  "/tag/add"   , route.tagAdd
app.post "/tag/save"  , route.tagSave
#app.get  "/tag/:id"   , route.tagById

#app.get  "/items"     , route.items
#app.get  "/item/form" , route.itemForm
app.get  "/item/add"  , route.itemAdd
app.post "/item/save" , route.itemSave
#app.get "/item/:name", route.itemByName

http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")
