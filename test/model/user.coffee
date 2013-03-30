routes   =  require "../../route/user.coffee"
User     =  require "../../model/User"
should   =  require "should"

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
      aname = "user-" + Date.now()
      req.body.user =
        login    : aname
        password : "password"
        salt     : "salt"
        name     : aname
        email    : aname+"@gmail.com"
        address  : "1234 te st"
        phone    : "555-5555"
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
