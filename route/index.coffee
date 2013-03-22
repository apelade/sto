#
# These functions are called by name from app.coffee routes
#

Tag = require "../model/Tag"
Item = require "../model/Item"

module.exports =
  
  # home index page
  index : (req, res) ->
    Item.find {}, (err, items) ->
      if ! items?
         items = []
      Tag.find {}, (err, tags) ->
        if ! tags?
          tags = []
        res.render "index",
          title: "The Whitney Portal"
          tags: tags
          items: items 
    
  # deliver some ajax data to caller: catalog.coffee
  ajaxNextTen: (req, res) ->
    query = req.query
    if query["page"]?
      page = Number(query["page"])
    if query["limit"]?
      limit = Number(query["limit"])
    skip = page * limit  
    Item.find {},{},{"skip":skip, "limit":limit}, (err, items) ->
      console.log err if err?
      returnObject = items
      returnObjectString = JSON.stringify(returnObject)
      res.writeHead(200, {'Content-Type': 'text/plain'})
      res.end( returnObjectString )

  # handle login get plain
  login_form: (req, res) ->
    res.render "login_form"
   
  # handle login post plain
  login: (req, res) ->
    if req.body.login  == 'pablo' && req.body.password== 'cody'
      req.session.user_id = "sweet100"
      res.redirect "/index"
  
  # handle login get with redirect
  # origPath is written into the post route on the template
  # route called from app.coffee route app.get "/loginPath/*:path?"
  login_redirect_form: (req, res) ->
    res.render "login_redirect_form",
      origPath: "/"+req.params.path
      
  # handle login post with redirect to original destination
  # route called from app.coffee route app.post "/loginPath/*:path?"
  login_redirect: (req, res) ->
    if req.body.login  == 'pablo' && req.body.password== 'cody'
      req.session.user_id = "sweet100" 
      res.redirect "/"+req.params.path
  