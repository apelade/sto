# /route/item.coffee

Tag = require "../model/Tag"
Item = require "../model/Item"


for key, path of Item.schema.paths
  module.exports[key] = do (key) ->
    afunc = (req, res) ->
      myKey = key
      myParam = req.params[myKey]
      constraint = {}
      constraint[myKey] = myParam
      Item.find constraint, (err, items) ->
        if not items?
          items = []    
        res.render "items",
          items: items

# show page to add items
module.exports.add = (req, res) ->
  Item.find {}, (err, items) ->
    if ! items?
       items = []
    Tag.find {}, (err, tags) ->
      if ! tags?
        tags = []
      res.render "item_add",
        title: "Now we're adding items."
        tags: tags
        items: items 

# handles form post
module.exports.save = (req, res) ->
  item = new Item(req.body.item)
  item.tags[item.tags.length] = req.body.tag
  item.save ->
    res.redirect "/item/add"
