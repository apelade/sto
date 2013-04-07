# /test/item.coffee

routes   =  require "../../route/item.coffee"
Tag      =  require "../../model/Tag"
Item     =  require "../../model/Item"
should   =  require "should"


describe "item", ->

  describe "#add()", ->
   it "should GET form for Items", (done) ->
     req = {}
     res = 
       render: (view, vars) ->
         view.should.equal "item_add"
     routes.add(req, res)
     done()

  describe "#save()", ->
    it "should save an Item to the db", (done) ->
      req = 
        params: {}
        body: {}
      aname = "itemtest-" + Date.now()
      req.body.item =
        tags  : []
        name  : aname
        model : "fashion"
        info  : "much more info at cnn.com"
        price : 5000

      routes.save req, redirect:  ->
        Item.findOne {name:aname}, (err, item) ->
          if item.name.should.equal aname
            console.log "\nItem " + aname + "added to db."
            Item.remove item, (err,res) ->
              console.log err if err?
              Item.findById item._id, (err, itemfound) ->
                should.not.exist(itemfound)
                console.log "Remove. Item in db after remove? " + itemfound?
                done()
                
  for key, path of Item.schema.paths
    console.log key
    do (key) ->
      console.log "Key is ", key
      req =
        params:{}
        body:{}
        url: "/item/" + key
      req.params[key] = "test"
      res = 
        render: (view, vars) ->
          if vars?.items?.length?
            console.log "Items found for ",key ,":",req.params[key]," == ",vars.items.length
            
          view.should.equal "items"
      func = routes[key]
      func(req, res)                