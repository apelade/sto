##### NOTE THIS MUST BE COMPILED WITH NO TOP-LEVEL FUNCTION
## IF NOT ERROR IS Catalog is not defined
# Depends on cart being in scope
initCat = () ->
  acatalog = new Catalog()
  # bind getnextten button
  acatalog.rebind()
  return acatalog

Catalog = () ->
  page = -1
  limit = 10
  # todo hardcoded parent
  parent = document.getElementById "catalogDiv"
  row = document.createElement "DIV"
  row.setAttribute "class", "row-fluid"
  cols = document.createElement "DIV"
  cols.setAttribute "class", "span12"
  cols.setAttribute "align", "center"
  parent.appendChild row
  row.appendChild cols
  cols.appendChild document.createTextNode " Page:"
  pageField = document.createElement "INPUT"
  pageField.setAttribute "TYPE", "text"
  pageField.setAttribute "ID", "pageField"
  cols.appendChild pageField
  button = document.createElement "INPUT"
  button.setAttribute "TYPE", "button"
  button.setAttribute "VALUE", "Next Ten"
  button.setAttribute "ID", "nextTenButton"
  cols.appendChild button 
  resultsDiv = document.createElement "DIV"
  parent.appendChild resultsDiv
  
  addItemDiv = (item, row) ->
    itemDiv = document.createElement "DIV"
    itemDiv.setAttribute "class", "span4" # for bootstrap
    row.appendChild(itemDiv)
    itemName = document.createElement "H2"
    itemName.appendChild document.createTextNode item.name 
    itemPrice = document.createTextNode formatCurrency item.price
    itemInfo = document.createTextNode item.info
    itemBtn = document.createElement "INPUT"
    itemBtn.setAttribute "type", "button"
    itemBtn.setAttribute "value", "Buy "+ item._id
    itemBtn.setAttribute "name", item._id
    itemBtn.setAttribute "class", "catItemBuyButton" # for event selector
    itemBtn.item = item
    itemDiv.appendChild itemName
    itemDiv.appendChild document.createElement "BR"
    itemDiv.appendChild itemPrice
    itemDiv.appendChild document.createElement "BR"
    itemDiv.appendChild itemInfo
    itemDiv.appendChild document.createElement "BR"
    itemDiv.appendChild itemBtn
  
  addItems = (items)->
    resultsDiv.innerHTML = ""
    row = null
    for item, i in items
      if i == 0 || i % 3 == 0
        row = document.createElement "DIV"
        row.setAttribute "class", "row-fluid" # for bootstrap
        resultsDiv.appendChild row
      addItemDiv(item, row)

 
  # ajax straight to db call, need some coalesce/dos prevention
  # or just have established options in cache 10/page 25/page served by nginx
  # or varnish, then this would become a load call
  fetchPage = () ->
    $.get "/nextTen",{page:page, limit:limit}, (data) ->
      if data != "[]"
        pageField.value = page
        addItems JSON.parse(data)
      else # wrap
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
          
  rebind = () ->
  
    $("#pageField").change () ->
      if page != Number(pageField.value) 
        page = Number(pageField.value) 
        fetchPage()

    $("#nextTenButton").click () ->
      page++
      fetchPage()
 
  return {
    rebind
  }
     
catalog = initCat()


#catalog = {}
#$(document).ready ->
#  catalog = initCat()