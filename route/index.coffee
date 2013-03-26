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
else
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
   
  # handle login post plain
  login: (req, res) ->
    log = req.body.login
    pass = req.body.password
    User.findOne {login:log}, (err, user) ->
      console.log err if err?
      if user?.password?
        if bcrypt?
          bcrypt.compare pass, user.password, (err, isMatch) ->
            console.log err if err?
            if isMatch == true
              req.session.user_id = "sweet100" 
              if req.params.path?
                res.redirect req.params.path
              else
                res.redirect "/"
            else
              delete req.session.user_id
              res.redirect "/"
        else if crypto?
          crypto.pbkdf2 pass, user.salt, 10000, 64, (err, derivedKey) ->
            if user.password is derivedKey
              console.log "Logged in"
              req.session.user_id = "sweet100" 
              if req.params.path?
                res.redirect req.params.path
              else
                res.redirect "/"
            else
              console.log "unsuccessful login attempt for ", user
              delete req.session.user_id
              res.redirect "/"
        