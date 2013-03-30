# /route/user.coffee

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
  req.body.user.password = hash.toString("base64")
  req.body.user.salt = salt
  user = new User(req.body.user)
  user.save ->
    if res?
      res.redirect "/user/add"    
    return user
    
for key, path of User.schema.paths
  module.exports[key] = do (key) ->
    afunc = (req, res) ->
      myKey = key
      myParam = req.params[myKey]
      constraint = {}
      constraint[myKey] = myParam
      User.find constraint, (err, users) ->
        if not users?
          users = []    
        res.render "users",
          users: users
          
# show page to add users
module.exports.add  = (req, res) ->
  User.find {}, (err, users) ->
    if ! users?
       users = []
    res.render "user_add",
      title: "Now we're adding users."
      users: users

# handles form post
module.exports.save = (req, res) ->
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
    if res?
      res.redirect "/"

# handle login post plain
module.exports.login = (req, res) ->
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
   