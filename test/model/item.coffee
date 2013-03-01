# /test/item.coffee

routes   =  require "../../route/item.coffee"
Tag      =  require "../../model/Tag"
Item     =  require "../../model/Item"
should   =  require "should"


describe "item", ->

  describe "#add()", ->
   it "should GET form for Items", ->
     req = {}
     res = 
       render: (view, vars) ->
         view.should.equal "item_add"
     routes.add(req, res)

  describe "#save()", (done)->
    it "should save an Item to the db", ->
      req = 
        params: {}
        body: {}
      name = "itemtest-" + Date.now()
      req.body.item =
        tags  : []
        name  : name
        model : "fashion"
        info  : "much more info at cnn.com"
        price : 5000

      routes.save req, redirect: (route) ->
        Item.findOne {name:name}, (err, item) ->
          if item.name.should.equal name
 #            console.log "\nItem " + name + "added to db."
            Item.remove item, (err,res) ->
  #              console.log err if err?
              Item.findById item._id, (err, itemfound) ->
                should.not.exist(itemfound)
  #              console.log "Remove. Item in db after remove? " + itemfound?
                done()