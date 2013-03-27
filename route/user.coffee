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
BASE_ITERATIONS = 10000
  
module.exports =

# show page to add users
  add : (req, res) ->
    User.find {}, (err, users) ->
      if ! users?
         users = []
      res.render "user_add",
        title: "Now we're adding users."
        users: users
#  
#  getIterations : (user, err, iterations) ->
#    if err?
#      return err
#    else if user?.login?.length?
#      return iterations = 10000 # res= BASE_ITERATIONS + (528 * user.login.length)
  
# handles form post
  save : (req, res) ->
    if req.body.user.password == req.body.repeatPassword
      pass = req.body.user.password
#      console.log "Passwords match"
      if bcrypt?
        bcrypt.genSalt SALT_WORK_FACTOR, (err, salt) ->
          if err?
            return err
          bcrypt.hash pass, salt, (err, hash) ->
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
#          getIterations(req.body.user,err,iterations) ->
#            console.log "ITERS == " + iterations
          crypto.pbkdf2 pass, salt, BASE_ITERATIONS, 64, (err, derivedKey) -> 
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
#          getIterations(user, err, iterations) ->
#            console.log "ITERS == " + iterations
          crypto.pbkdf2 pass, user.salt, BASE_ITERATIONS, 64, (err, derivedKey) ->
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
        