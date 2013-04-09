routes   = require "../../route/index"

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
  it "should get some catalog items", ->
    # todo 1 Note currently needs to be required in /test/index.coffee as well!
    sa = require "superagent"
    sa.agent()
    .get("http://localhost:3000/nextTen?page=0&limit=10")
    .type("json")
    .set('Accept', 'application/json')    
    .end((data) ->
      len = JSON.parse(data.text).length     
      console.log " Next Ten results ", len
    )
    
    
#    $ = require "jquery"
#    $.ajax(
#      type:"GET"
#      url:"http://localhost:3000/nextTen?page=0&limit=10"
#      dataType:"json"
#    )
#    .success (res) ->
#      console.log "nextTen results.length ", res.length
#      console.log "Next ten results ", res
#    .error (err) ->
#      console.log "nextTen error ", err
#    .complete (xhr, status) ->
#      console.log "nextTen complete with status ", status