routes   = require "../../route/index"

res = 
  redirect: (route) ->
    # do nothing
  render: (view, vars) -> 
    # do nothing

describe "index", ->
  it "should show index page with items", ->
    req = null
    res = 
      render: (view, vars) ->
        view.should.equal "index"
        vars.title.should.equal "The Whitney Portal"
#          vars.items.should.eql []
    routes.index(req, res)
