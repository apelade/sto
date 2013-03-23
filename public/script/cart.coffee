##### NOTE THIS MUST BE COMPILED WITH NO TOP-LEVEL FUNCTION
## IF NOT ERROR IS Cart is not defined
# records look like this, with cartObj[id] == obj[id]
# cartObj[id]:{obj:{}, qty:num}
# Depends on: /script/util.js

purgeCart = () ->
  localStorage.setItem "cart", JSON.stringify({})

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
    # ifccess by childNodes[x] once this file stabilizes
    qtyField = row.getElementsByClassName("quantity")[0]
    bind(qtyField, "keypress", isNumKey)
    # onpaste clipboard data only available in IE, not using.
    isNumChange["cart"] = cart
    bind(qtyField, "change", isNumChange)

# used by refresh,  todo, get rid of at some pt
parentDivName = ""

init = () ->
  acart = new Cart()
  element = acart.getElement()
  # todo hardcoded parent
  parentDivName = "cartDiv"
  document.getElementById(parentDivName).appendChild(element)
  bindRowFields(acart, document.getElementsByClassName("itemRow"))
  return acart


##### NOTE THIS MUST BE COMPILED WITH NO TOP-LEVEL FUNCTION
#### Cart Class ####

Cart = () ->

  CART = "cart"
  myElement = null
  
  pullCart = () ->
    localCart = getLocalObject(CART)
    if localCart?
      return localCart
    else return {}

  pushCart = (cartObj) ->
    setLocalObject(CART, cartObj)
    #return pullCart 
  
  # If id exists as a cart key, the val is incremented, else initialized to 1
  addItem = (id, name, model, info, price) ->
    cartObj = pullCart()
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
    pushCart(cartObj)
    refresh()
    return cartObj

  # Called when user changes qty field in cart
  setItemQuantity = (id, quantity) ->
    cartObj = pullCart()
    if cartObj[id]?
      if Number(quantity) == 0 # todo handle maximum limit
        delete cartObj[id]
      else
        cartObj[id]["qty"] = Number(quantity)
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
 
  makeRow = (obj, quantity) -> 
    #todo: check obj fields exist
    tr = document.createElement "TR"
    tr.setAttribute "ID", "tr"+obj.id
    tr.setAttribute "CLASS", "itemRow" 

    td1 = document.createElement "TD"
    td1.appendChild document.createTextNode(obj.id)
    tr.appendChild td1
    
    td2 = document.createElement "TD"
    td2.appendChild document.createTextNode(obj.name)
    tr.appendChild td2
    
    td3 = document.createElement "TD"
    td3.appendChild document.createTextNode(obj.model)  
    tr.appendChild td3
      
    td4 = document.createElement "TD"
    td4.appendChild document.createTextNode(formatCurrency(obj.price))
    td4.align = "left"
    tr.appendChild td4

    td5 = document.createElement "TD"
    qtyField = document.createElement "INPUT"
    qtyFieldSize = "3"
    qtyField.setAttribute "SIZE", qtyFieldSize
    qtyField.setAttribute "MAXLENGTH", qtyFieldSize
    qtyField.setAttribute "TYPE", "text"
    qtyField.setAttribute "CLASS", "quantity" 
    qtyField.setAttribute "ID", obj.id
    qtyField.setAttribute "VALUE", quantity
    td5.appendChild qtyField
    tr.appendChild td5
    
    td6 = document.createElement "TD"
    lineTotal = Number(obj.price) * Number(quantity)
    td6.appendChild document.createTextNode(formatCurrency(lineTotal))
    td6.align = "right"
    tr.appendChild td6
    return tr
  
  initElement = ->
    totalCost = 0
    totalQty = 0
    console.log "INIT ELEMENT"
    table = document.createElement "TABLE"
    table.setAttribute "NAME", "cartTable"
    tableBody = document.createElement "TBODY"
    tableFoot = document.createElement "TFOOT"
    table.appendChild tableBody
    # table.appendChild(tableFoot) removed -- no .colspan
    pc = pullCart()
    for itemkey of pc
      obj = pc[itemkey]["obj"]
      qty = pc[itemkey]["qty"]
      if obj? && qty? && obj.price?
        tableBody.appendChild makeRow(obj, qty)
        totalCost += (Number(qty) * Number(obj.price))
        totalQty += Number(qty)
    subtotalRow = document.createElement "TR"
    tdWord = document.createElement "TD"
    tdWord.setAttribute "colspan", "5"
    tdWord.setAttribute "align", "right"
    tdWord.appendChild document.createTextNode " " + totalQty + " items :  "
    tdCost = document.createElement "TD"
    tdCost.setAttribute "align", "left"
    tdCost.appendChild document.createTextNode(formatCurrency(totalCost))
    subtotalRow.appendChild tdWord
    subtotalRow.appendChild tdCost
    tableBody.appendChild subtotalRow
    myElement = table
    return myElement
      
  getElement = () ->
    return myElement? or initElement()
  
  # todo: rather a blunt instrument here..  
  refresh = () ->
    if myElement?
      document.getElementById(parentDivName).removeChild(myElement)
      myElement = null
      document.getElementById(parentDivName).appendChild(initElement())
      bindRowFields(cart, document.getElementsByClassName("itemRow"))
      
  # return public methods, otherwise error message is "Object has no method x"
  return {
    addItem
    setItemQuantity
    toString
    getElement
  }

cart = {}
$(document).ready ->
  cart = init()
