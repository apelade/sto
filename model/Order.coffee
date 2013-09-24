mongoose = require 'mongoose'

  
# _id is a mongodb ObjectId added automatically
Order = new mongoose.Schema(
  _id:{type:mongoose.Schema.Types.ObjectId},
  user:{type:mongoose.Schema.Types.ObjectId},
  created:{type:Date},
  items:[
    item:{type:mongoose.Schema.Types.ObjectId}
    price:{type:Number}
    quantity:{type:Number}
  ]
)


module.exports = mongoose.model 'Order', Order