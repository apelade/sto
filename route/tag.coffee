# /route/tag.coffee
Item = require "../model/Item"
Tag = require "../model/Tag"

module.exports = 

# show form on GET
  add : (req, res) ->
    Tag.find {}, (err, tags) ->
      res.render "tag_add",
        title: "Now we are tagging!"
        tags: tags

# handles form post
  save : (req, res) ->
    tag = new Tag(req.body.tag)
    tag.save ->
      res.redirect "/tag/add"

  byId : (req, res) ->
    Tag.find {_id:req.params.id}, (err, tags) ->
      if not tags?
        tags = []
      res.render "tags",
        tags: tags
    
  byName : (req, res) ->
    console.log req.params.name
    Tag.find {name:req.params.name}, (err, tags) ->
      if not tags?
        tags = []
      res.render "tags",
        tags: tags
        