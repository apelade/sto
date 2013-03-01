#routes   = require "../../route/index"
mongoose = require "mongoose"
#Tag      =  require "../../model/Tag"
#should   =  require "should"
#Item     =  require "../../model/Item"
CONNECT_STR = "mongodb://sto_user:reverse@linus.mongohq.com:10083/mdb"
if mongoose.connection.readyState is 0
  mongoose.connect CONNECT_STR
#require "../../test/model/tag.coffee"
#require "../../test/model/item.coffee"
