# todo 1, switch to example of test dirs, otherwise have to do this here
# AND in /test/index/index.coffee
require "superagent"

describe "overall test", ->
  it "should be the entry point to scripting test execution", ->

    require "../test/db/dbconn.coffee"
    require "../test/index/index.coffee"
    require "../test/model/tag.coffee"
    require "../test/model/item.coffee"
    require "../test/model/user.coffee"
