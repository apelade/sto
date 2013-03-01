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
      name = "tagtest-" + Date.now()
      req.body.tag =
        name : name

      routes.save req, redirect: (route) ->
        Tag.findOne {name:name}, (err, tag) ->
          if tag.name.should.equal name
            Tag.remove tag, (err,res) ->
              Tag.findById tag._id, (err, tagfound) ->
                done()
