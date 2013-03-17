##### NOTE THIS MUST BE COMPILED WITH NO TOP-LEVEL FUNCTION
## IF NOT ERROR IS Catalog is not defined
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
  button.setAttribute "ID", "nextTen"
  parent.appendChild button 
  
  field = document.createElement "INPUT"
  field.setAttribute "TYPE", "text"
  parent.appendChild field
  

  
  fetchPage = () ->
    $.get "nextTen",{page:page, limit:limit}, (data) ->
      if data != "[]"
        field.value = data
        pageField.value = page
      else # wrap
        page = 0   
        $.get "nextTen",{page:page, limit:limit}, (data) ->
          field.value = data
          pageField.value = page
        
  $("#pageField").change () ->
    page = Number(pageField.value) 
    fetchPage()
  
  $("input[type='button']").click () ->
    page++
    fetchPage()
  

    
  return {
    nextTen
  }

catalog = initCat()
console.log "ITEMS APPEARS To be:  " + items
