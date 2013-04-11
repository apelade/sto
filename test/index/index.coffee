routes   = require "../../route/index"


    
describe "index", ->
  it "should show index page with items", ->
    req = null
    res = 
      render: (view, vars) ->
        view.should.equal "index"
        vars.title.should.equal "The Whitney Portal"
#          vars.items.should.eql []
    routes.index(req, res)

describe "nextTen", ->
  it "should get some catalog items", ->
    # todo 1 Note currently needs to be required in /test/index.coffee as well!
    sa = require "superagent"
    # process.env is used running in c9.io
    myhost = process.env.IP or "localhost"
    myport = process.env.PORT or "3000"
    myuri = "http://" + myhost + ":" + myport + "/nextTen?page=0&limit=10"
    sa.agent()
    .get(myuri)
    .type("json")
    .set('Accept', 'application/json')    
    .end((data) ->
      len = JSON.parse(data.text).length     
      console.log " Next Ten results ", len
    )
############## jquery version of same ################
#  
#    $ = require "jquery"
#    $.ajax(
#      type:"GET"
#      url:"http://localhost:3000/nextTen?page=0&limit=10"
#      dataType:"json"
#    )
#    .success (res) ->
#      console.log "nextTen results.length ", res.length
#      console.log "Next ten results ", res
#    .error (err) ->
#      console.log "nextTen error ", err
#    .complete (xhr, status) ->
#      console.log "nextTen complete with status ", status
########################################

describe "checkout", ->
  it "should checkout as if button clicked", ->
  
  cart = {}
    # Called when user changes qty field in cart
  addItem = (id, name, model, info, price) ->
    # cart stores items by key = item.id
    cartItem = cart[id]
    if ! cartItem?
      cartItem = {}
      qty = 1
      cartItem["obj"] =
        id:id
        name:name
        model:model
        info:info
        price:price
      cartItem["qty"] = qty
    else
      console.log cartItem.qty
      numInCart = Number(cartItem.qty)
      cartItem["qty"] = numInCart + 1
    cart[id] = cartItem  
 
  addItem("123", "Ted", "1996 Spring", "best in wet weather", 25.25)
  addItem("222", "Romaine", "1999 Winter", "cute", 11.11)
  addItem("333", "Jedi-REPEATER", "EZ open", "bargain", 12.12)
  addItem("444", "Franklin", "Wacky Fun", "witty you are", 33.33)
  addItem("555", "Shawna-REPEATER", "1970 style", "best all around", 77.00)
  addItem("555", "Shawna-REPEATER", "1970 style", "best all around", 77.00)
  addItem("333", "Jedi-REPEATER", "EZ open", "bargain", 12.12)
  addItem("333", "Jedi-REPEATER", "EZ open", "bargain", 12.12)
  
  sa = require "superagent"
  # process.env is used running in c9.io
  myhost = process.env.IP or "localhost"
  myport = process.env.PORT or "3000"
  myuri = "http://" + myhost + ":" + myport + "/checkout"
  sa.agent()
  .post(myuri)
  .type("json")
  .send(cart)
  .set('Accept', 'application/json')    
  .end((data) ->
    # currently ships us back the same thing, would do paypal conf redirect, etc
    retcart = JSON.parse(data.res.text)
    console.log "\nCheckout. Number of Unique items. UNIQUE. ", Object.keys(retcart).length
  )
  
  
#describe "paypal return", ->
#  it "should receive redirect from paypal", ->
# req =
#  query:
#    token:EC-5VR65326E2667870C
#    PayerID:N428HMW29J6SQ
# res = 
#   render: (view, vars) ->
#     view.should.equal "paypal_confirm"
#     vars.title.should.equal "Confirmation Page"
#          vars.items.should.eql []
#    routes.paypal(req, res)      

