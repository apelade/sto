##### NOTE THIS MUST BE COMPILED WITH NO TOP-LEVEL FUNCTION
## IF NOT ERROR IS Catalog is not defined
# Depends on cart being in scope
initCat = () ->
  catalog = new Catalog()
  return catalog

Catalog = () ->
  
  page = -1
  limit = 10
  
  # todo hardcoded parent
  parent = document.getElementById "catalogDiv" 
  parent.appendChild document.createTextNode " Page:"
  pageField = document.createElement "INPUT"
  pageField.setAttribute "TYPE", "text"
  pageField.setAttribute "ID", "pageField"
  parent.appendChild pageField
  button = document.createElement "INPUT"
  button.setAttribute "TYPE", "button"
  button.setAttribute "VALUE", "Next Ten"
  button.setAttribute "ID", "nextTenButton"
  parent.appendChild button 
  resultsDiv = document.createElement "DIV"
  parent.appendChild resultsDiv
  
  addItemDiv = (item) ->
    itemDiv = document.createElement "DIV"
    itemDiv.setAttribute("class", "catItemDiv") # for style
    itemName = document.createElement "H2"
    itemName.appendChild( document.createTextNode( item.name ) )
    itemPrice = document.createTextNode( formatCurrency(item.price) )
    itemInfo = document.createTextNode( item.info)
    itemBtn = document.createElement("INPUT")
    itemBtn.setAttribute("type", "button")
    itemBtn.setAttribute("value", "Buy "+ item._id)
    itemBtn.setAttribute("name", item._id)
    itemBtn.setAttribute("class", "catItemBuyButton")
    itemBtn.item = item
    itemDiv.appendChild(itemName)
    itemDiv.appendChild(document.createElement("BR"))
    itemDiv.appendChild(itemPrice)
    itemDiv.appendChild(document.createElement("BR"))
    itemDiv.appendChild(itemInfo)
    itemDiv.appendChild(document.createElement("BR"))
    itemDiv.appendChild(itemBtn)
    resultsDiv.appendChild(itemDiv)

  # ajax straight to db call, need some coalesce/dos prevention
  # or just have established options in cache 10/page 25/page served by nginx
  
  addItems = (items )->
    resultsDiv.innerHTML = ""
    for item in items
      addItemDiv( item )
  
  fetchPage = () ->
    $.get "nextTen",{page:page, limit:limit}, (data) ->
      if data != "[]"
        pageField.value = page
        addItems JSON.parse(data)
      else # wrap
        # if we got nothing on page zero, give up
        if page == 0
          msg =  "Got nothing on page zero, giving up"
          console.log msg
          return msg
        else
          page = 0
          fetchPage()
      $('input[class=catItemBuyButton]').click (event) ->
        if event.target.item?
          # eti is the item object itself, attached to button in addItemDiv
          eti = event.target.item
          cart.addItem(eti._id, eti.name, eti.model, eti.info, eti.price)   
        
  $("#pageField").change () ->
    page = Number(pageField.value) 
    fetchPage()
  
  $("#nextTenButton").click () ->
    page++
    fetchPage()

catalog = initCat()
