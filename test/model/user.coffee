routes   =  require "../../route/user.coffee"
User     =  require "../../model/User"
should   =  require "should"

aname = "user-" + Date.now()
testUser = 
  login    : aname
  password : "password"
  salt     : "salt"
  name     : aname
  email    : aname+"@gmail.com"
  address  : "1234 te st"
  phone    : "555-5555"
  
describe "user", ->

  describe "#add()", ->
   it "should GET form for Users", (done) ->
     req = {}
     res = 
       render: (view, vars) ->
         view.should.equal "user_add"
     routes.add(req, res)
     done()

  describe "#save()", ->
    it "should save a User to the db", (done) ->
      req = 
        params: {}
        body: {}
      req.body.user = testUser
      req.body.repeatPassword = req.body.user.password

      routes.save req, redirect:  ->
        User.findOne {name:aname}, (err, user) ->
          if user.email.should.equal aname+"@gmail.com"
            console.log "\nUser " + aname + "added to db."
            User.remove user, (err,res) ->
              console.log err if err?
              User.findById user._id, (err, userfound) ->
                should.not.exist(userfound)
                console.log "Remove. User in db after remove? " + userfound?
                done()

   for key, path of User.schema.paths
     console.log key
     do (key) ->
       console.log "Key is ", key
       req =
         params:{}
         body:{}
         url: "/user/" + key
       req.params[key] = "ed"
       res = 
         render: (view, vars) ->
          console.log view, vars
          view.should.equal "users"
       console.log "REQ: " , req
       console.log "RES: " , res
       func = routes[key]
       func(req, res)

#  for key, func of routes.qRoutes
##    console.log key, func
##    do =>
#    describe "#queryRoute.User."+key, ->
#      varkey = key
#      varfunc = func
#      if key not in ["password", "salt"]
#        it "should run a query route for User."+key, -> #  (done) ->
##          console.log "varkey is " + varkey
##          console.log "func is " + func
##          console.log "varfunc is " + varfunc
##          console.log "testUser.key is ", testUser[varkey]
#          req =
#            params:{}
#            body:{}
#            url: "/user/" + varkey
#          req.params[varkey] = testUser[varkey]
#          res = 
#            render: (view, vars) ->
#              console.log view, vars
#              view.should.equal "userspoop"
##          () ->
##          func.myKey = varkey
#          func(req, res, varkey)
#            done()

#          func(req, res) ->
#            console.log "OK"
  