mongoose =  require "mongoose"
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

# todo 1 mongo connection fails occasionally, add reconnect code or forever?
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
  if !req.session?.user_id?
    res.render "login_form",
      redirectPath : req.url
  else
    next()

# routes
app.get "/index*|/$", route.index
app.get "/nextTen", route.ajaxNextTen
app.post "/checkout", route.ajaxCheckout
app.get "/paypal/confirm:query?", route.paypalConfirm
#app.get "/paypal/ok", route.paypalComplete

# called from login_form as a result of checkUser
userRoutes = require "./route/user.coffee"
app.post "/login*:path?", userRoutes.login

# routes for mongoose models in models dir, protected by checkUser
fs = require "fs"
fs.readdir (__dirname + '/model/'), (err,files) ->
  # map of request method types for each model function
  modMap =
    add:"get",
    save:"post"

  try
    for file in files
      words = file.split "."    
      if words?[1] is "coffee"
        modName = words[0].toLowerCase()
        modObj = require "./route/"+modName+".coffee"
        for funcName of modMap
          reqMethName = modMap[funcName]
          path = "/"+modName+"/"+funcName
          console.log reqMethName, path
          app[reqMethName] path, checkUser, modObj[funcName]
          # To skip checkUser, uncomment this line and comment out above
          # app[reqMethName] "/"+modName+"/"+funcName, modObj[funcName]
        
        # add get routes that query mongoose model fields
        mod = require "./model/"+words[0]+".coffee"
        modPaths = mod.schema.paths
        for pathName, path of modPaths
          if pathName not in ["password", "salt"]
            extra = "/:"+pathName+"?"
            fullpath = "/"+modName+"/"+pathName+extra
            console.log "get " + "/"+modName+"/"+pathName+extra 
            app.get fullpath, checkUser, modObj[pathName]  
  catch err
    console.log err if err?

http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")
  for route in app.routes.get
    console.log route.method, route.path
  for route in app.routes.post
    console.log route.method, route.path   