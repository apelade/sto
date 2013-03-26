#
# These functions are called by name from app.coffee routes
#

User = require "../model/User"
module_exist = require "./module_exist.coffee"
bcrypt = null
SALT_WORK_FACTOR = 10
if module_exist.found("bcrypt")
  bcrypt = require "bcrypt"
else
  crypto = require "crypto"
  
module.exports =

# show page to add users
  add : (req, res) ->
    User.find {}, (err, users) ->
      if ! users?
         users = []
      res.render "user_add",
        title: "Now we're adding users."
        users: users

# handles form post
  save : (req, res) ->
    if req.body.user.password == req.body.repeatPassword
#      console.log "Passwords match"
      if bcrypt?
        bcrypt.genSalt SALT_WORK_FACTOR, (err, salt) ->
          if err?
            return err
          bcrypt.hash req.body.user.password , salt, (err, hash) ->
            if err?
              return err
            req.body.user.password  = hash
            user = new User(req.body.user)
            user.save ->
              res.redirect "/user/add"
      else if crypto?
        # hash this with the user salt and admin-resticted access file script
        crypto.randomBytes 64, (ex, buf) ->
          salt = req.body.user.login + (buf).toString "base64"
          # uses SHA-1
          crypto.pbkdf2 req.body.user.password, salt, 10000, 64, (err, derivedKey) ->
            if err?
              log err
            req.body.user.password = derivedKey.toString("base64")
            req.body.user.salt = salt
            user = new User(req.body.user)
            user.save ->
              res.redirect "/user/add"      
    else
      console.log "Passwords must match"
      res.redirect "."