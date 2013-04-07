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

describe "nextTen", ->
  it "should get some catalog items",  ->
    $ = require "jquery"
    $.ajax(
      type:"GET"
      url:"http://localhost:3000/nextTen?page=0&limit=10"
      dataType:"json"
    )
    .success (res) ->
      console.log "nextTen results.length ", res.length
      console.log "Next ten results ", res
    .error (err) ->
      console.log "nextTen error ", err
    .complete (xhr, status) ->
      console.log "nextTen complete with status ", status