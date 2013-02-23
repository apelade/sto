
#
# * GET home page.
# 
module.exports =
  
  index : (req, res) ->
    res.render "index",
      title: "Whitney Lives"
      items: []
      
  add_item : (req, res) ->
    res.render "add_item",
      title: "Add Item"

