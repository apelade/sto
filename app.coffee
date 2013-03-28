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
      redirectPath : req.route.path
  else
    next()
    
app.get  "/index*|/$", route.index
app.get  "/nextTen", route.ajaxNextTen
# called from login_form as a result of checkUser
userRoutes = require "./route/user.coffee"
app.post "/login*:path?", userRoutes.login
# Routes for mongoose models in models dir, protected by checkUser
fs = require "fs"
fs.readdir (__dirname + '/model/'), (err,files) ->
  # Map of request method types for each model function
  modMap =
    add:"get",
    save:"post",
    byId:"get",
    byName:"get"
  try
    for file in files
      words = file.split "."    
      if words?[1] is "coffee"
        modelName = words[0].toLowerCase()
        modelObj = require "./route/"+modelName+".coffee"
        for funcName of modMap
          reqMethName = modMap[funcName]
          extra = ""
          param = funcName.toLowerCase().split "by"
          if param? && param.length is 2 && param[0] is ''
            extra = "/:"+param[1]+"?"
          app[reqMethName] "/"+modelName+"/"+funcName+extra , checkUser, modelObj[funcName]
        
        if modelName is "item"
          mod = require "./model/Item.coffee"
          modPaths = mod.schema.paths
          for pathName, path of modPaths
#            console.log "pathName == ", pathName
#            console.log "func  == ", modelObj[pathName]
            extra = "/:"+pathName+"?"
            console.log "path == " + "/"+modelName+"/"+pathName+extra 
            app.get  "/"+modelName+"/"+pathName+extra, modelObj[pathName]  
            
  catch err
    console.log err if err?

http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")
