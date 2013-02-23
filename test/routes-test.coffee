routes = require "../route/index"
require "should"

describe "route", ->
  describe "index", ->
    it "should display index page with items", ->
      req = null
      res = 
        render: (view, vars) ->
          view.should.equal "index"
          vars.title.should.equal "Whitney Lives"
          vars.items.should.eql []
      routes.index(req, res)
