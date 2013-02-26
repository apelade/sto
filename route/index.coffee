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
          
## commented-out because tag_add.jade incorporates these via include
#  tagForm : (req, res) ->
#    res.render "tag_form",
#
## display tags list fragment
#  tags : (req, res) ->
#    Tag.find {}, (err, tags) ->
#      res.render "tags",
#        title: "Tags"
#        tags: tags
 
# show page to add tags
  tagAdd : (req, res) ->
    Tag.find {}, (err, tags) ->
      res.render "tag_add",
        title: "Now we are tagging!"
        tags: tags

# handles form post
  tagSave : (req, res) ->
    tag = new Tag(req.body.tag)
    tag.save ->
      res.redirect "/tag/add"
      
## commented-out because item_add.jade inocorporates these via include
# # passes tags for selection at item create time
#  itemForm: (req, res) ->
#    Tag.find {}, (err, tags) ->
#      res.render "item_form",
#        tags: tags
#
## display items list fragment
#  items : (req, res) ->
#    Item.find {}, (err, items) ->
#        res.render "items",
#          title: "Items"
#          items: items

# show page to add items
  itemAdd : (req, res) ->
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
  itemSave : (req, res) ->
    item = new Item(req.body.item)
    item.tags[item.tags.length] = req.body.tag
    item.save ->
      res.redirect "/item/add"
