var bind, exists, formatCurrency, getLocalObject, isNormalInteger, isTypedDigit, setLocalObject;

if (typeof (typeof Storage !== "undefined" && Storage !== null)) {
  console.log("Yes! localStorage and sessionStorage support!");
} else {
  console.log("Sorry! No web storage support");
}

setLocalObject = function(key, val) {
  return localStorage.setItem(key, JSON.stringify(val));
};

getLocalObject = function(key) {
  var val;
  val = localStorage.getItem(key);
  return val && JSON.parse(val);
};

bind = function(el, evt, func) {
  if (el.addEventListener) {
    return el.addEventListener(evt, func, false);
  } else if (el.attachEvent) {
    return el.attachEvent("on" + evt, func);
  }
};

formatCurrency = function(num) {
  num = (isNaN(num) || num === "" || num === null ? 0.00 : num);
  return "$ " + parseFloat(num).toFixed(2);
};

isTypedDigit = function(charCode) {
  var keyChar;
  keyChar = String.fromCharCode(charCode);
  if ("0123456789".indexOf(keyChar) > -1) {
    return true;
  } else {
    return false;
  }
};

isNormalInteger = function(str) {
  var n;
  n = ~~Number(str);
  return String(n) === str && n >= 0;
};

exists = function(obj) {
  return typeof arg !== "undefined" && arg !== null;
};
