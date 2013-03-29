# /route/tag.coffee

Tag = require "../model/Tag"

for key, path of Tag.schema.paths
  module.exports[key] = do (key) ->
    afunc = (req, res) ->
      myKey = key
      myParam = req.params[myKey]
      constraint = {}
      constraint[myKey] = myParam
      Tag.find constraint, (err, tags) ->
        if not tags?
          tags = []    
        res.render "tags",
          tags: tags

# show form on GET
module.exports.add = (req, res) ->
  Tag.find {}, (err, tags) ->
    res.render "tag_add",
      title: "Now we are tagging!"
      tags: tags

# handles form post
module.exports.save = (req, res) ->
  tag = new Tag(req.body.tag)
  tag.save ->
    res.redirect "/tag/add"
      