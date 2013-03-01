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
 
