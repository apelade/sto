mongoose = require 'mongoose'

 
# flatten to contain primary contact info
User = new mongoose.Schema(
  login   : String
  password: String
  name    : String
  email   : String
  address : String
  phone   : String
)

# todo Ensure unique index on the date for next previous
module.exports = mongoose.model 'User', User
