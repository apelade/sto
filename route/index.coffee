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
          
          
# handles get for form in view/add_tag.jade
  add_tag : (req, res) ->
    res.render "add_tag",
      title: "Add a new tag item"

# handles form post
  addTag : (req, res) ->
    tag = new Tag(req.body.tag)
    tag.save ->
    # /tags route calls showTags
      res.redirect "/tags"

# display tags list fragment
  showTags : (req, res) ->
    Tag.find {}, (err, tags) ->
      res.render "tags",
        title: "Whitney Lives"
        tags: tags
 
 # handles get for form in view/add_tag.jade
 # passes tags for selection at item create time
  add_item : (req, res) ->
    Tag.find {}, (err, tags) ->
      res.render "add_item",
        title: "New Item"
        tags: tags


# handles form post
  addItem : (req, res) ->
    item = new Item(req.body.item)
    item.tags[item.tags.length] = req.body.tag
#    item.cats.push req.body.cat
    item.save ->
      # /items route calls showItems 
      res.redirect "/items"

# display items list fragment
  showItems : (req, res) ->
    Item.find {}, (err, items) ->
        res.render "items",
          title: "Some items"
          items: items
