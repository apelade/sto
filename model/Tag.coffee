mongoose = require 'mongoose'

Tag = new mongoose.Schema(
  name: { type:String, unique:true, sparse:true, trim:true, lowercase:true}
  , {collection:'tag'} 
)  

module.exports = mongoose.model 'Tag', Tag
