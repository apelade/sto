#
# These functions are called by name from app.coffee routes
#

User = require "../model/User"
crypto = require "crypto"

module_exist = require "./module_exist.coffee"
bcrypt = null
SALT_WORK_FACTOR = 10
if module_exist.found("bcrypt")
  bcrypt = require "bcrypt"

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
  
    console.log "REQ.BODY.user === " + req.body.user.password
    console.log "REQ.BODY.repeatPassword === " + req.body.repeatPassword
    if req.body.user.password == req.body.repeatPassword
      console.log "Passwords match"
      if bcrypt?
        # generate a salt
        bcrypt.genSalt SALT_WORK_FACTOR, (err, salt) ->
          if err?
            return err
          # hash the password
          bcrypt.hash req.body.user.password , salt, (err, hash) ->
              if err?
                return err
              req.body.user.password  = hash
              user = new User(req.body.user)
              user.save ->
                res.redirect "/user/add"
                
      else if crypto?
        # hash this with the user salt and admin-resticted access file script
        keylen = 256
        crypto.randomBytes keylen, (ex, buf) ->
          salt = (req.body.user.login + buf).toString "hex"
          iterations = 64000
          crypto.pbkdf2 req.body.user.password, salt, iterations, keylen, (err, derivedKey) ->
            if err?
              log err
            console.log "DERIVED KEY : " , derivedKey
            req.body.user.password = derivedKey
            req.body.user.salt = salt
            user = new User(req.body.user)
            user.save ->
              res.redirect "/user/add"      
        
    else
      console.log "Passwords don't match"
      res.redirect "."