#
# These functions are called by name from app.coffee routes
#

Tag = require "../model/Tag"
Item = require "../model/Item"

module.exports =

# show page to add items
  add : (req, res) ->
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
  save : (req, res) ->
    item = new Item(req.body.item)
    item.tags[item.tags.length] = req.body.tag
    item.save ->
      res.redirect "/item/add"
