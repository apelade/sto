#
# These functions are called by name from app.coffee routes
#

Tag = require "../model/Tag"
Item = require "../model/Item"


#paginate = (model, page, numShown) ->
#  model.find( { skip: (page * numShown), limit: numShown }, (err, results) { ... });

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

  

    
# deliver some ajax data caller:
  
  ajaxNextTen: (req, res) ->
    # add pg, per to req.params
    query = req.query
    console.log "query == ", query
    if query["page"]?
      page = Number(query["page"])
    if query["limit"]?
      limit = Number(query["limit"])
    skip = page * limit  
    Tag.find {},{},{"skip":skip, "limit":limit}, (err, tags) ->
      console.log err if err?
      console.log "ajaxGetTen skip limit == ", skip, limit
      returnObject = tags
      returnObjectString = JSON.stringify(returnObject)
      res.writeHead(200, {'Content-Type': 'text/plain'})
      res.end( returnObjectString )
