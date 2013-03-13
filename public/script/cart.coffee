##### NOTE THIS MUST BE COMPILED WITH NO TOP-LEVEL FUNCTION
## IF NOT ERROR IS Cart is not defined


# records look like this, with cart[id] == obj[id]
# cartObj[id]:{obj:{}, qty:num}

#### Util #####

if typeof(Storage)?
  console.log "Yes! localStorage and sessionStorage support!"
else
  console.log "Sorry! No web storage support"

# Don't mess with Storage prototypes, delegate
setLocalObject = (key, val) ->
  localStorage.setItem(key, JSON.stringify(val))

getLocalObject = (key) ->
  val = localStorage.getItem(key)
  return val && JSON.parse(val)

bind = (el, evt, func) ->
  console.log("Binder: ", el, evt, func)
  if el.addEventListener
    return el.addEventListener(evt, func, false)
  else if el.attachEvent
    return el.attachEvent("on"+evt, func)      

purgeCart = () ->
  localStorage.setItem "cart", JSON.stringify({})
  
formatCurrency = (num) ->
  num = (if isNaN(num) or num is "" or num is null then 0.00 else num)
  return "$ " + parseFloat(num).toFixed 2
  
isTypedDigit = (charCode) ->
  keyChar = String.fromCharCode(charCode)
  if "0123456789".indexOf(keyChar) > -1
    return true
  else
    return false 
    
isNormalInteger = (str) ->
    n = ~~Number(str);
    return String(n) == str && n >= 0

#### Validation ####
# Both these functions are args to bind(), inner functions called by listeners
# So, return values can't be used, yet.

# Only allow user to enter numbers
isNumKey = () ->
  console.log "Key Press"
  hap = window.event or e
  isNum = false
  if typeof hap.which == "number"
    isNum = isTypedDigit(hap.which)
  else isNum = isTypedDigit(hap.keyCode) #IE
  if ! isNum
    if hap.preventDefault
      hap.preventDefault()
    else
      hap.returnValue = false #IE


# On exit, validate contents, could be from paste or dragndrops
# If valid, sets item qty directy
isNumChange = () ->
  console.log "isNumChange"
  hap = window.event or e
  isNum = false
  value = this.value
  prev = this.defaultValue

  if isNormalInteger(value) == false
    # todo better alert
    this.setAttribute "style", "background-color : #ffaaaa"
    this.value = ""
    this.focus()
  else
    this.setAttribute "style", "background-color : #ffffff"
    cart = isNumChange.cart
    # calls pullCart() at start of function
    cart.setItemQuantity(this.id, this.value)
      
bindRowFields = (cart, itemRows) ->
  console.log "bindRF rows", itemRows
  len = itemRows.length
  rowArray = [len]
  for i in [0..len-1] by 1
    row = itemRows[i]
    # Instead access by childNodes[x] once this file stabilizes
    qtyField = row.getElementsByClassName("quantity")[0]
    bind(qtyField, "keypress", isNumKey)
    # onpaste clipboard data only available in IE, not using.
    isNumChange["cart"] = cart
    bind(qtyField, "change", isNumChange)


# used by refresh, for now todo, get rid of at some pt
parentDivName = ""
loadCart = (divName) ->
  cart = new Cart()
  element = cart.getElement()
  parentDivName = divName
  document.getElementById(divName).appendChild(element);
  bindRowFields(cart, document.getElementsByClassName("itemRow"))
  return cart

##### NOTE THIS MUST BE COMPILED WITH NO TOP-LEVEL FUNCTION

#### Cart ####

Cart = () ->
    
    
  CART = "cart"
  myElement = null
  
  pullCart = () ->
#    purgeCart()
#    return {}
    localCart = getLocalObject(CART)
    if localCart?
      return localCart
    else return {}

  pushCart = (cartObj) ->
    setLocalObject(CART, cartObj)
    #return pullCart 
  
  # If id exists as a cart key, the val is incremented, or else initialized to 1
  addItem = (id, name, model, info, price) ->
#    purgeCart()
    cartObj = pullCart()
    console.log "ADD ITEM cart ", pullCart()
    # cart stores items by key = item.id
    cartItem = cartObj[id]
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
    cartObj[id] = cartItem  
    console.log "ITEM == ", cartItem
    pushCart(cartObj)
    refresh()
    return cartObj

  # Called when user changes qty field in cart
  setItemQuantity = (id, quantity) ->
#    console.log "SET I Q cart == ", cartObj

    cartObj = pullCart()
    if cartObj[id]?
      if Number(quantity) == 0 # todo handle maximum limit
        delete cartObj[id]
      else
        cartObj[id][qty] = Number(quantity)
    else # (! cartObj[id]?)
      cartObj[id]["obj"] =
        name:name
        model:model
        info:info
        price:price
      cartObj[id]["qty"] = quantity
    pushCart(cartObj)
    refresh()
    return cartObj
    
  # If id exists as a cart key, and the val is greater than 1, decrement
#  removeItem = (id) ->
#    cartObj = pullCart()
#    if cartObj?[id]? > 0
#      if cartObj[id][qty] == 1
#        delete cartObj[id]
#      else
#        cartObj[id][qty] = Number(cartObj[id][qty]) - 1
#      pushCart(cartObj)
#    else
#      console.log "Tried to remove non-existent cart item."
#      console.log "Id with brackets flanking it: >>>" + id + "<<<"
#    return cartObj
#
#  toString = () ->
#    return localStorage.getItem(CART)
    
    
  # TEST DEV ONLY REPLACE WITH REALS   
#  price = 5.259
#  cat = "cat"
#  abbr = "abbr"
#  name = "name"
  
  #{item._id}', '#{item.name}' ,'#{item.model}' ,'#{item.info}' ,#{item.price}
  makeRow = (obj, quantity) ->
    
#    console.log "OBJ makey is ", obj
    console.log obj.id
    console.log obj.name
    console.log obj.model
    console.log obj.info
    console.log obj.price
#    return null
#    
    #todo: check obj fields exist
    tr = document.createElement("TR")
    tr.setAttribute "ID", "tr"+obj.id
    tr.setAttribute("CLASS", "itemRow")

    td1 = document.createElement("TD")
    td1.appendChild document.createTextNode(obj.id)
    tr.appendChild td1
    
    td2 = document.createElement("TD")
    td2.appendChild document.createTextNode(obj.name)
    tr.appendChild td2
    
    td3 = document.createElement("TD")
    td3.appendChild document.createTextNode(obj.model)  
    tr.appendChild td3
      
    td4 = document.createElement("TD")
#      td5.align = "right"
    td4.appendChild document.createTextNode(formatCurrency(obj.price))
    tr.appendChild td4

    td5 = document.createElement("INPUT")
    qtyFieldSize = "3"
    td5.setAttribute "SIZE", qtyFieldSize
    td5.setAttribute "MAXLENGTH", qtyFieldSize
    td5.setAttribute "TYPE", "text"
    td5.setAttribute "CLASS", "quantity" 
    td5.setAttribute "ID", obj.id
#      td5.setAttribute("style", "font-family: Courier New, monospace;")
    td5.setAttribute "VALUE", quantity
    tr.appendChild td5
    
    return tr
  
  
  TEST_TOTAL = 250.00  
  initElement = ->
    console.log("INIT ELEMENT")
    table = document.createElement("TABLE")
    table.setAttribute "NAME", "cartTable"
    tableBody = document.createElement("TBODY")
    tableFoot = document.createElement("TFOOT")
    table.appendChild(tableBody)
    table.appendChild(tableFoot)
    pc = pullCart()
    for itemkey of pc#just gets the keys
      obj =  pc[itemkey]["obj"]
      qty =  pc[itemkey]["qty"]
      tableBody.appendChild makeRow(obj, qty)
    subtotalRow = document.createElement("TR")
    tdWord = document.createElement("TD")
    tdWord.colspan = "4";
    tdWord.align = "right"
    tdWord.appendChild document.createTextNode("Subtotal")
    tdCost = document.createElement("TD")
    tdCost.appendChild document.createTextNode(formatCurrency(TEST_TOTAL))
    subtotalRow.appendChild tdWord
    subtotalRow.appendChild tdCost
    tableFoot.appendChild subtotalRow
    myElement = table
    return myElement
      
  getElement = () ->
    return myElement? or initElement()
  
  # todo: rather a blunt instrument here..  
  refresh = () ->
    if myElement?
      document.getElementById(parentDivName).removeChild(myElement);
      myElement = null
      document.getElementById(parentDivName).appendChild(initElement());
      bindRowFields(cart, document.getElementsByClassName("itemRow"))
      
  # return public methods, otherwise error message is "Object has no method x"
  return {
#    bind
    addItem
    setItemQuantity
#    refresh
#    removeItem
    toString
    getElement
  }


