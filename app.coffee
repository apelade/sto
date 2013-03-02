mongoose = require "mongoose"
express = require "express"
fs = require "fs"
route = require "./route/"
http = require "http"
path = require "path"
fs = require "fs"
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

# Include default routes for mongoose models in models dir
fs.readdir (__dirname + '/model/'), (err,files) ->

  # What we look for in the models, our interface, with request type
  iModel =
    add:"get",
    save:"post"

  try
    for file in files
      words = file.split "."    
      if words?[1] is "coffee"
        modelName = words[0].toLowerCase()
        modelObj = require "./route/"+modelName+".coffee"
        for funcName of iModel
          # post or get
          reqMethName = iModel[funcName]
          app[reqMethName] "/"+modelName+"/"+funcName , modelObj[funcName]
  catch err
    console.log err if err?

http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")
