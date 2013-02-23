#
# * GET home page.
#

Tag = require "../model/Tag"

module.exports =
  
  index : (req, res) ->
    Tag.find {}, (err, tags) ->
      if ! tags?
        tags = []
      res.render "index",
        title: "Whitney Lives"
        tags: tags

# handles get for form in view/add_tag.jade
  add_tag : (req, res) ->
    res.render "add_tag",
      title: "Add a new tag item"

# handles form post
  addTag: (req, res) ->
    tag = new Tag(req.body.tag)
    tag.save ->
      Tag.find {}, (err, tags) ->
        res.render "index",
          title: "Whitney Lives"
          tags: tags
      