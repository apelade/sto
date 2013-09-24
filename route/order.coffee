# /route/order.coffee


Order = require "../model/Order"

module.exports.add = (req, res) ->
  console.log "Order.add called"

# handles form post
module.exports.save = (req, res) ->
  console.log "Order.save called"