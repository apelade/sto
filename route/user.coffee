User = require "../model/User"
module_exist = require "./module_exist.coffee"
bcrypt = null
SALT_WORK_FACTOR = 10
if module_exist.found("bcrypt")
  bcrypt = require "bcrypt"
else
  crypto = require "crypto"
BASE_ITERATIONS = 10000
   

handleLogin = (req, res, err, user, ok) ->
  console.log err if err?
  if ok
    console.log "Logged in"
    req.session.user_id = "sweet100" 
    return res.redirect req.params.path if req.params.path?
  else
    console.log "unsuccessful login attempt for ", user
    delete req.session.user_id
  res.redirect "/"

handleSave = (req, res, err, salt, hash) ->
  console.log err if err?
  req.body.user.password = derivedKey.toString("base64")
  req.body.user.salt = salt
  user = new User(req.body.user)
  user.save ->
    res.redirect "/user/add"    
       
       
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
      pass = req.body.user.password
      if bcrypt?
        bcrypt.genSalt SALT_WORK_FACTOR, (err, salt) ->
          bcrypt.hash pass, salt, (err, hash) ->
            handleSave(req,res,err,salt,hash) 
      else if crypto?
        crypto.randomBytes 64, (ex, buf) ->
          salt = req.body.user.login + (buf).toString "base64"
          crypto.pbkdf2 pass, salt, BASE_ITERATIONS, 64, (err, hash) -> 
            handleSave(req,res,err,salt,hash) 
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
            handleLogin(req, res, err, user,isMatch)
        else if crypto?
          crypto.pbkdf2 pass, user.salt, BASE_ITERATIONS, 64, (err, hash) ->
            isMatch = user.password is hash
            handleLogin(req, res, err, user, isMatch )
   
     
  byId : (req, res) ->
    User.find {_id:req.params.id}, (err, users) ->
      if not users?
        users = []
      res.render "users",
        users: users
    
  byName : (req, res) ->
    User.find {name:req.params.name}, (err, users) ->
      if not users?
        users = []    
      res.render "users",
        users: users