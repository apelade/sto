Tag = require "../model/Tag"
Item = require "../model/Item"
User = require "../model/User"
module_exist = require "./module_exist.coffee"
bcrypt = null
SALT_WORK_FACTOR = 10
if module_exist.found("bcrypt")
  bcrypt = require "bcrypt"
else
  crypto = require "crypto"
  
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
    
  # deliver some ajax data to catalog.coffee on click of nextTen button
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
 
  ajaxCheckout: (req, res) ->
    console.log "AJAX CHECKOUT ", req.body if req?.body
    if req?.body?
    # It would redirect to a print this page for your records invoice page
      res.writeHead(200, {'Content-Type': 'application/json'})
      res.end( JSON.stringify(req.body) )
