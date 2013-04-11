Tag = require "../model/Tag"
Item = require "../model/Item"
User = require "../model/User"
module_exist = require "./module_exist.coffee"
payper = require "./payper"

bcrypt = null
SALT_WORK_FACTOR = 10
if module_exist.found("bcrypt")
  bcrypt = require "bcrypt"
else
  crypto = require "crypto"

pending = {}
auth_token = null
module.exports =
  
  # home index page
  index : (req, res) ->
    Item.find {}, (err, items) ->
      if ! items?
        items = []
      Tag.find {}, (err, tags) ->
        if ! tags?
          tags = []
        res.render "index",
          title: "The Whitney Portal"
          tags: tags
          items: items 
    
  # deliver some ajax data to catalog.coffee on click of nextTen button
  ajaxNextTen: (req, res) ->
    query = req.query
    if query["page"]?
      page = Number(query["page"])
    if query["limit"]?
      limit = Number(query["limit"])
    skip = page * limit  
    Item.find {},{},{"skip":skip, "limit":limit}, (err, items) ->
      console.log err if err?
      returnObject = items
      returnObjectString = JSON.stringify(returnObject)
      res.writeHead(200, {'Content-Type': 'text/plain'})
      res.end( returnObjectString )

  # Route: /paypal/confirm:query?
  # called by paypal as callback of return_url below
  paypalConfirm: (req, origRes) ->
    if req.query?
      fakepayer =
        payer_id: req.query.PayerID
      payment_id = pending[req.query.token]
      #todo a local getToken function
      payper.executePayment payment_id, fakepayer, auth_token, (req, res) ->
        origRes.render "paypal_complete",
          data: JSON.stringify(res.body)

  # Route: /checkout
  # cart submission from checkout button in public/script/cart.js
  ajaxCheckout: (req, res) ->
    console.log "AJAX CHECKOUT ", req.body if req?.body
    if req?.body?
      client_id = 'AfKBwBA_Npl3wGoWJ6VGOiyVHVAEZsfyH5_6jNf6i_xnDS0GksDX79BrMjSA'
      client_secret = 'EFovbhBrTtbR18sU8I_SCFXcuYd5iSdOszil-P-rFD9n5LXwKkHt_GyLuMGG'
      payper.getToken client_id, client_secret, (err, data) ->
        console.log err if err? 
        auth_token = data.body.access_token
        console.log "Token == ", auth_token
        # todo 1 where to keep this -- good for 8 hrs. Cron credentials?
        host = process.env.IP or 'localhost'
        port = process.env.PORT or '3000'
        return_url = 'http://' + host + ':' +  port + '/paypal/confirm' # confirmation page
        cancel_url = 'http://' + host + ':' +  port + '/' # cancel page
        
        fakepayment = {
          "intent":"sale",
          "redirect_urls":{
            "return_url":return_url,
            "cancel_url":cancel_url
          },
          "payer":{
            "payment_method":"paypal"
          },
          "transactions":[
            {
              "amount":{
                "total":"7.49",
                "currency":"USD"
              },
              "description":"This is the nice payment transaction description."
            }
          ]
        }
        
        # Create a payment with the test object.
        payper.createPayment fakepayment, token, (err,result) ->
          if err?
            console.log "CREATE PAYMENT error : ", err
          # To eventually execute a payment needs the payment id but only
          # a transaction token is received in params from the return_url
          # callback above.
          # In app.coffee, that route is mapped to paypalConfirm function above.
          # Stash it here and look it up in paypalConfirm.
          # This activity should be in the db in a real app.
          linkstr = result.body.links[1].href.toString()
          if linkstr.indexOf("token=") > -1
            temptoken = linkstr.substr(linkstr.indexOf("token=")+6)
            pending[temptoken] = result.body.id
          stringbody = JSON.stringify(result.body)
          res.writeHead(200, {'Content-Type': 'application/json'})
          res.end( stringbody )

