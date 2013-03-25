mongoose = require "mongoose"
express = require "express"
fs = require "fs"
route = require "./route/"
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
  app.use express.cookieParser()
  app.use express.session({ secret: 'chamwosley chirrupkas' })
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

# Send user to login if they are accessing restricted routes
checkUser = (req,res,next) ->
  console.log "ROUTE: " , req.route
  if !req.session?.user_id?
    res.render "login_form",
      origPath : req.route.path
  else
    next()
  
app.get  "/index*|/$", route.index
app.get  "/nextTen", route.ajaxNextTen
# Called from login_form as a result of checkUser
app.post "/login*:path?", route.login

# Routes for mongoose models in models dir
fs = require "fs"
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
          # To skip checkUser for first user, temporarily use the first line:
          # app[reqMethName] "/"+modelName+"/"+funcName , modelObj[funcName]
          # Ordinarily, use this line with checkUser middleware inline:
          app[reqMethName] "/"+modelName+"/"+funcName , checkUser, modelObj[funcName]
  catch err
    console.log err if err?

http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")
