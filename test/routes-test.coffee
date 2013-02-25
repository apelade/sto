routes = require "../route/index"
mongoose = require "mongoose"
shouldpkg = require "should"
Tag = require "../model/Tag"
Item = require "../model/Item"
CONNECT_STR = "mongodb://sto_user:reverse@linus.mongohq.com:10083/mdb"
mongoose.connect CONNECT_STR

res = 
  redirect: (route) ->
    # do nothing
  render: (view, vars) -> 
    # do nothing
      
describe "route", ->
  describe "index", ->
    it "should display index page with items", ->
      req = null
      res = 
        render: (view, vars) ->
          view.should.equal "index"
          vars.title.should.equal "The Whitney Portal"
#          vars.items.should.eql []
      routes.index(req, res)

  describe "tags", ->
    it "should display Tags", ->
      req = null
      res = 
        render: (view, vars) ->
          view.should.equal "tags"
      routes.showTags(req, res)
  
  describe "add tag", ->
    it "should data entry form for Tags", ->
      res = 
        render: (view, vars) ->
          view.should.equal "add_tag"
  
  describe "save tag", ->
    it "should save a Tag to the db", (done)->
      req = 
        params: {}
        body: {}
      
      name = "gabbytables" + Date.now()
      req.body.tag =
        name: name
        
      routes.addTag req, redirect: (route) ->
        route.should.eql "/tags"
        routes.showTags req, render: (view, vars) ->
          view.should.equal "tags"
          vars.tags[vars.tags.length-1].name.should.equal name
          Tag.findOne({name:name}, (err, tag) ->
            tag.name.should.equal name
            console.log "\nTag " + name + " was added to db."
            Tag.remove(tag, (err,res) ->
              console.log err if err?
              Tag.findById(tag._id, (err, tagfound) ->
                shouldpkg.not.exist(tagfound)
                console.log "Remove. Tag in db after remove? " + tagfound?
                done()
              )
            ))
              
              
  describe "items", ->
    it "should display Items", ->
      req = null
      res = 
        render: (view, vars) ->
          view.should.equal "items"
      routes.showItems(req, res)

  describe "add item", ->
    it "should data entry form for Items", ->
      res = 
        render: (view, vars) ->
          view.should.equal "add_item"
  
  describe "save item", ->
    it "should save an Item to the db", (done)->
      req = 
        params: {}
        body: {}
      name = "itemidiom" + Date.now()
      req.body.item =
        tags  : []
        name  : name
        model : "fashion"
        info  : "much more info at cnn.com"
        price : 5000
        
      routes.addItem req, redirect: (route) ->
        route.should.eql "/items"
        routes.showItems req, render: (view, vars) ->
          view.should.equal "items"
          vars.items[vars.items.length-1].name.should.equal name        
          Item.findOne({name:name}, (err, item) ->
            if(item.name.should.equal name)
              console.log "\nItem " + name + "added to db."
            Item.remove(item, (err,res) ->
              console.log err if err?
              Item.findById(item._id, (err, itemfound) ->
                shouldpkg.not.exist(itemfound)
                console.log "Remove. Item in db after remove? " + itemfound?
                done()
              )
            ))

