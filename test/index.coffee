describe "overall test", ->
  it "should be the entry point to scripting test execution", ->
    require "../test/db/dbconn.coffee"
    require "../test/index/index.coffee"
    require "../test/model/tag.coffee"
    require "../test/model/item.coffee"
    require "../test/model/user.coffee"
