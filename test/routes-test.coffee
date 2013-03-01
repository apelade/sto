routes = require "../route/index"
mongoose = require "mongoose"
Tag = require "../model/Tag"
should = require "should"
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
    it "should show index page with items", ->
      req = null
      res = 
        render: (view, vars) ->
          view.should.equal "index"
          vars.title.should.equal "The Whitney Portal"
#          vars.items.should.eql []
      routes.index(req, res)

  describe "add tag", ->
    it "should data entry form for Tags", ->
      req = {}
      res =
        render: (view, vars) ->
          view.should.equal "tag_add"        
      routes.tagAdd(req, res)

  describe "tagSave", ->
    it "should save a Tag to the db", (done)->
      req = 
        params: {}
        body: {}
      name = "tagtestyy-" + Date.now()
      req.body.tag =
        name : name

      routes.tagSave req, redirect: (route) ->
        Tag.findOne {name:name}, (err, tag) ->
          if tag.name.should.equal name
#            console.log "\nItem " + name + "added to db."
            Tag.remove tag, (err,res) ->
  #            console.log err if err?
              Tag.findById tag._id, (err, tagfound) ->
                should.not.exist(tagfound)
#                console.log "Remove. Item in db after remove? " + tagfound?
                done()

  describe "add item", ->
    it "should show entry form for Items", ->
      req = {}
      res = 
        render: (view, vars) ->
          view.should.equal "item_add"
      routes.itemAdd(req, res)

  describe "itemSave", (done)->
    it "should save an Item to the db", ->
      req = 
        params: {}
        body: {}
      name = "itemtestxxxxxxxx-" + Date.now()
      req.body.item =
        tags  : []
        name  : name
        model : "fashion"
        info  : "much more info at cnn.com"
        price : 5000

      routes.itemSave req, redirect: (route) ->
        Item.findOne {name:name}, (err, item) ->
          if item.name.should.equal name
#            console.log "\nItem " + name + "added to db."
            Item.remove item, (err,res) ->
  #              console.log err if err?
              Item.findById item._id, (err, itemfound) ->
                should.not.exist(itemfound)
  #              console.log "Remove. Item in db after remove? " + itemfound?
                done()




