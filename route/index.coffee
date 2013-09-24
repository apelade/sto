Tag = require "../model/Tag"
Item = require "../model/Item"
User = require "../model/User"
Order = require "../model/Order"
payper = require "./payper"

pending = {}
auth_token = null
fn = console.log
addToList = (list, id, qty, fn) ->
  return () -> fn list
  
# todo this is a near dupe of public/script/utils.coffee function
formatCurrency = (num) ->
  num = (if isNaN(num) or num is "" or num is null then 0.00 else num)
  return parseFloat(num).toFixed 2
  
module.exports =
  

  
  # Route: /index*|/$
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
  
  # Route: /nextTen  
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
  # called by paypal as redirect from paypal.com in return_url below
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
  # Don't rely on the req to provide prices: Check with db.
  # If different, can show users the "updated" price to manage price changes
  ajaxCheckout: (req, res) ->
    funcs = []
    line_items = []
    for key, item of req.body
      id = item['obj']['id']
      quantity = Number(item['qty'])
      func = ((item_id, qty) ->
        ->
          #line_items[item_id] = {'price':null, 'quantity':qty}
          line_items[item_id] = {'item':item_id, 'price':null, 'quantity':qty}
          )(id, quantity)
      func()
    keys = (k for k, v of line_items )
    Item.find {'_id': { $in: keys }}, (err, docs) ->
      total_price = 0
      for doc in docs
        item = line_items[doc._id]
        item.price = doc.price
        quant = line_items[doc._id]['quantity']
        total_price = total_price + (item.price * quant)
      totalPrice = formatCurrency(total_price)
      console.log 'total_price is ', total_price
      
      item_array = (v for k, v of line_items)
      console.log "date is ", Date.now()
      ord = new Order({'created':Date.now(),'items':item_array})
      console.log "Order is ", ord
      ord.save ->
        console.log 'save order'

      if req?.body?
        client_id = 'AfKBwBA_Npl3wGoWJ6VGOiyVHVAEZsfyH5_6jNf6i_xnDS0GksDX79BrMjSA'
        client_secret = 'EFovbhBrTtbR18sU8I_SCFXcuYd5iSdOszil-P-rFD9n5LXwKkHt_GyLuMGG'
        payper.getToken client_id, client_secret, (err, data) ->
          console.log err if err? 
          auth_token = data.body.access_token
          console.log "Auth Token == ", auth_token
          # todo 1 where to keep this -- good for 8 hrs. Cron credentials?
          host_port = 'localhost:3000'
          if process?.env?.IP?
            host_port = 'sto.apelade.c9.io' 
          
          return_url = 'http://' + host_port + '/paypal/confirm' # confirmation page
          cancel_url = 'http://' + host_port + '/' # cancel page
          
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
                  "total":total_price,
                  "currency":"USD"
                },
                "description":"This is the nice payment transaction description."
              }
            ]
          }
          
          # Create a payment with the test object.
          payper.createPayment fakepayment, auth_token, (err,result) ->
            if err?
              console.log "CREATE PAYMENT error : ", err
            # To eventually execute a payment needs the payment id but only
            # a transaction token is received in params from the return_url
            # callback above.
            # In app.coffee, that route is mapped to paypalConfirm function above.
            # Stash it here and look it up in paypalConfirm.
            # This activity should be in the db in a real app.
            #console.log "result.body is ", result.body
            linkstr = result.body.links[1].href.toString()
            console.log "linkstr : ", linkstr
            if linkstr.indexOf("token=") > -1
              temptoken = linkstr.substr(linkstr.indexOf("token=")+6)
              pending[temptoken] = result.body.id
            stringbody = JSON.stringify(result.body)
            res.writeHead(200, {'Content-Type': 'application/json'})
            res.end( stringbody )


