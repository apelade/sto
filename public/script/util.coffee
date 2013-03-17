#### utils used by cart and catalog components #####

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
  if el.addEventListener
    return el.addEventListener(evt, func, false)
  else if el.attachEvent
    return el.attachEvent("on"+evt, func)      

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
