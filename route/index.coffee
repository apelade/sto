Tag = require "../model/Tag"
Item = require "../model/Item"
User = require "../model/User"
module_exist = require "./module_exist.coffee"
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
 
 

  
  paypalConfirm: (req, res) ->
    console.log "paypalConfirm", req.query
#    console.log "paypalConfirm REQ: ",req
#    console.log "paypalConfirm RES: ", res
    if req.query?
      payper = require "../lib/payper"
      fakepayer =
        payer_id: req.query.PayerID
#      console.log "querytoken", req.query.token
#      console.log "pending", pending
      
      payment_id = pending[req.query.token]
#      console.log "payment_id", payment_id
#      console.log "auth_token", auth_token
      
      #todo a local getToken function
      payper.executePayment payment_id, fakepayer, auth_token
#      { token: 'EC-0HJ17629X9476391M', PayerID: 'N428HMW29J6SQ' }
#    console.log "paypalConfirm REQ: ",req
#    console.log "paypalConfirm RES: ", res
    
 
  paypalOK: (req, res) ->
    res.send("OK")
    
  ajaxCheckout: (req, res) ->
    console.log "AJAX CHECKOUT ", req.body if req?.body
    if req?.body?
      payper = require "../lib/payper"
      client_id = 'AfKBwBA_Npl3wGoWJ6VGOiyVHVAEZsfyH5_6jNf6i_xnDS0GksDX79BrMjSA'
      client_secret = 'EFovbhBrTtbR18sU8I_SCFXcuYd5iSdOszil-P-rFD9n5LXwKkHt_GyLuMGG'
      payper.getToken client_id, client_secret, (err, data) ->
        console.log err if err? 
        token = data.body.access_token
        console.log "Token == ", token
        # todo 1 where to keep this -- good for 8 hrs.
        auth_token = token
        host = process.env.IP or 'localhost'
        port = process.env.PORT or '3000'
        return_url = 'http://' + host + ':' +  port + '/paypal/ok' # confirmation page
        cancel_url = 'http://' + host + ':' +  port + '/user/add' # cancel page
        
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
        ###
          Create a payment with the test object
        ### 
        
#        {"href":"https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=EC-0HJ17629X9476391M","rel":"approval_url","method":"REDIRECT"},{"href":"http
        payper.createPayment fakepayment, token, (err,result) ->
          if err?
            console.log "CREATE PAYMENT error : ", err
          linkstr = result.body.links[1].href.toString()
          if linkstr.indexOf("token=") > -1
            temptoken = linkstr.substr(linkstr.indexOf("token=")+6)
            console.log "TT", temptoken
            console.log "TV", result.body.id
            pending[temptoken] = result.body.id
            console.log "pending", pending
            
          stringbody = JSON.stringify(result.body)
          console.log stringbody
          res.writeHead(200, {'Content-Type': 'application/json'})
          res.end( stringbody )

