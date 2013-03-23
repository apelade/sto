#
# These functions are called by name from app.coffee routes
#

User = require "../model/User"
#crypto = require "crypto"
bcrypt = require "bcrypt"
SALT_WORK_FACTOR = 10

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
      # generate a salt
      bcrypt.genSalt SALT_WORK_FACTOR, (err, salt) ->
        if err?
          return err

        # hash the password with salt
        bcrypt.hash req.body.user.password , salt, (err, hash) ->
            if err?
              return err
            
            req.body.user.password  = hash
            user = new User(req.body.user)
            user.save ->
              res.redirect "/user/add"            

    else
      console.log "Passwords don't match"
      res.redirect "."