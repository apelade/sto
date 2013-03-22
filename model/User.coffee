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


# can enforce pass hashing on save, or validate with pre's
User.pre "save", (next) ->
  console.log "pre save"
  next()

# todo Ensure unique index on the date for next previous
module.exports = mongoose.model 'User', User
