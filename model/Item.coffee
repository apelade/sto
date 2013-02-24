mongoose = require 'mongoose'
ObjectId = mongoose.ObjectId
# Tag = require "../models/Tag"
 
# _id is a mongodb ObjectId added automatically
Item = new mongoose.Schema(
  tags: [ObjectId]
  name: String
  model: String
  info: String
  price: Number
)

# todo Ensure unique index on the date for next previous
module.exports = mongoose.model 'Item', Item
