mongoose = require "mongoose"
express = require "express"
fs = require "fs"
route = require "./route/"
# todo:1
route_tag = require "./route/tag.coffee"
route_item = require "./route/item.coffee"


#fs.readdir (__dirname + '/route/'), (err,files)->
#  files = 
#  flen = files.length
#  while flen-- > 0
#      file = files[i]
#      dot = file.lastIndexOf('.')
#      if file.substr(dot + 1) is 'coffee'
#         name = file.substr(0, dot)
#         require('./routes/' + name)(app, argv)  

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

#console.log route
#app.get  "/route/tag/add", route.tag.add

app.get  "/tag/add"   , route_tag.add
app.post "/tag/save"  , route_tag.save
#app.get  "/tag/:id"   , route.tagById

app.get  "/item/add"  , route_item.add
app.post "/item/save" , route_item.save
#app.get "/item/:name", route.itemByName

http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")
