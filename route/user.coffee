#
# These functions are called by name from app.coffee routes
#

User = require "../model/User"

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
    user = new User(req.body.user)
    user.save ->
      res.redirect "/user/add"
