# /route/tag.coffee
#Item = require "../model/Item"
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

#byId = (req, res) ->
#  Tag.find {_id:req.params.id}, (err, tags) ->
#    if not tags?
#      tags = []
#    res.render "tags",
#      tags: tags
#module.exports.byId = byId
#
#byName = (req, res) ->
#  console.log req.params.name
#  Tag.find {name:req.params.name}, (err, tags) ->
#    if not tags?
#      tags = []
#    res.render "tags",
#      tags: tags
#module.exports.byName = byName
#        