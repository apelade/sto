# /route/tag.coffee

Tag = require "../model/Tag"

# Supply a query route for each mongoose model object field.
# like /tag/name/terb
module.exports.queryRoutes = () ->
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
module.exports.queryRoutes()

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
      