#
# These functions are called by name from app.coffee routes
#
Tag = require "../model/Tag"
Item = require "../model/Item"
User = require "../model/User"
module_exist = require "./module_exist.coffee"
bcrypt = null
SALT_WORK_FACTOR = 10
if module_exist.found("bcrypt")
  bcrypt = require "bcrypt"
  
crypto = require "crypto"

module.exports =
  
  # home index page
  index : (req, res) ->
    Item.find {}, (err, items) ->
      if ! items?
         items = []
      Tag.find {}, (err, tags) ->
        if ! tags?
          tags = []
        res.render "index",
          title: "The Whitney Portal"
          tags: tags
          items: items 
    
  # deliver some ajax data to caller: catalog.coffee
  ajaxNextTen: (req, res) ->
    query = req.query
    if query["page"]?
      page = Number(query["page"])
    if query["limit"]?
      limit = Number(query["limit"])
    skip = page * limit  
    Item.find {},{},{"skip":skip, "limit":limit}, (err, items) ->
      console.log err if err?
      returnObject = items
      returnObjectString = JSON.stringify(returnObject)
      res.writeHead(200, {'Content-Type': 'text/plain'})
      res.end( returnObjectString )

  # handle login get plain
  login_form: (req, res) ->
    res.render "login_form"
   
  # handle login post plain
  login: (req, res) ->
    log = req.body.login
    pass = req.body.password
#      checkAuth log, pass, (err, result) ->
    User.findOne {login:log}, (err, user) ->
      console.log "result pass for log: " + log + " is "
      console.log "user: " , user
      console.log err if err?
#        req.session.user_id = "sweet100" 
#        res.redirect "/"+req.params.path
      if user?.password?
        console.log "respass == ", user.password
        
        if bcrypt?
          bcrypt.compare pass, user.password, (err, isMatch) ->
            console.log err if err?
            if isMatch == true
              req.session.user_id = "sweet100" 
              if req.params.path?
                res.redirect "/"+req.params.path
              else
                res.redirect "/"
            else
              delete req.session.user_id
              res.redirect "/"
        else if crypto?
          console.log "USER.salt isss ", user.salt
          hmac = crypto.createHmac('sha256', user.salt).update(pass).digest("hex")
          console.log "HMAC == " + hmac
          console.log "UPASS == " + user.password
          if user.password.toString "hex" == hmac
            console.log "HMAC MATCH PW"
            req.session.user_id = "sweet100" 
            if req.params.path?
              res.redirect "/"+req.params.path
            else
              res.redirect "/"
          else
            delete req.session.user_id
            res.redirect "/"
  
  # handle login get with redirect
  # origPath is written into the post route on the template
  # route called from app.coffee route app.get "/loginPath/*:path?"
  login_redirect_form: (req, res) ->
    res.render "login_redirect_form",
      origPath: "/"+req.params.path
  
#  checkAuth : (log,pass,cb) ->
#    User.findOne {login:log}, (err, result) ->
#      console.log "result pass for log: " + log + " is ", result.password
#      if result?.password?
#        bcrypt.compare pass, result.password, (err, isMatch) ->
#          if err?
#            return cb(err)
#          cb(null, true)
  # handle login post with redirect to original destination
  # route called from app.coffee route app.post "/loginPath/*:path?"
  
#  login_redirect: (req, res) ->
##    if req.body.login  == 'pablo' && req.body.password== 'cody'
#      log = req.body.login
#      pass = req.body.password
##      checkAuth log, pass, (err, result) ->
#      User.findOne {login:log}, (err, result) ->
#        console.log "result pass for log: " + log + " is "
#        console.log "result: " , result
#        console.log err if err?
##        req.session.user_id = "sweet100" 
##        res.redirect "/"+req.params.path
#        if result?.password?
#          console.log "respass == ", result.password
#          bcrypt.compare pass, result.password, (err, isMatch) ->
#            console.log err if err?
#            if isMatch == true
#              req.session.user_id = "sweet100" 
#              res.redirect "/"+req.params.path
#            else
#              delete req.session.user_id
#              res.redirect "/"
      