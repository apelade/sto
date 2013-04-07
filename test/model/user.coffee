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
  for key, path of User.schema.paths
    describe "a field-based route"+key, ->
      it "should query the field for Users matching "+key, ->
        do (key) ->
          req =
            params:{}
            body:{}
            url: "/user/" + key
          req.params[key] = "ff"
          res = 
            render: (view, vars) ->
              console.log view, vars
              view.should.equal "users"
#          console.log "REQ: " , req
#          console.log "RES: " , res
          func = routes[key]
          func(req, res)


#  describe "#add()", ->
#   it "should GET form for Users", (done) ->
#     req = {}
#     res = 
#       render: (view, vars) ->
#         view.should.equal "user_add"
#     routes.add(req, res)
#     done()
#
#  describe "#save()", ->
#    it "should save a User to the db", (done) ->
#      req = 
#        params: {}
#        body: {}
#      req.body.user = testUser
#      req.body.repeatPassword = req.body.user.password
#
#      routes.save req, redirect:  ->
#        User.findOne {name:aname}, (err, user) ->
#          if user.email.should.equal aname+"@gmail.com"
#            console.log "\nUser " + aname + "added to db."
#            User.remove user, (err,res) ->
#              console.log err if err?
#              User.findById user._id, (err, userfound) ->
#                should.not.exist(userfound)
#                console.log "Remove. User in db after remove? " + userfound?
#                done()

    
       