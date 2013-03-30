  # /test/tag.coffee

routes   =  require "../../route/tag.coffee"
Tag      =  require "../../model/Tag"
should   =  require "should"

describe "tag", ->

  describe "#add()", ->
    it "should GET form for Tags", ->
      req = {}
      res =
        render: (view, vars) ->
          view.should.equal "tag_add"        
      routes.add(req, res)

  describe "#save()", ->
    it "should save a Tag to the db", (done)->
      req = 
        params: {}
        body: {}
      aname = "tagtest-" + Date.now()
      req.body.tag =
        name : aname

      routes.save req, redirect: ->
        Tag.findOne {name:aname}, (err, tag) ->
          if tag.name.should.equal aname
            console.log "\nTag " + aname + " added to db"
            Tag.remove tag, (err,res) ->
              Tag.findById tag._id, (err, tagfound) ->
                console.log err if err?
                should.not.exist tagfound
                console.log "Removed tag found anymore? " + tagfound?
                done()

