var Cart, bind, bindRowFields, formatCurrency, getLocalObject, isNormalInteger, isNumChange, isNumKey, isTypedDigit, loadCart, parentDivName, purgeCart, setLocalObject;

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
  console.log("Binder: ", el, evt, func);
  if (el.addEventListener) {
    return el.addEventListener(evt, func, false);
  } else if (el.attachEvent) {
    return el.attachEvent("on" + evt, func);
  }
};

purgeCart = function() {
  return localStorage.setItem("cart", JSON.stringify({}));
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

isNumKey = function() {
  var hap, isNum;
  console.log("Key Press");
  hap = window.event || e;
  isNum = false;
  if (typeof hap.which === "number") {
    isNum = isTypedDigit(hap.which);
  } else {
    isNum = isTypedDigit(hap.keyCode);
  }
  if (!isNum) {
    if (hap.preventDefault) {
      return hap.preventDefault();
    } else {
      return hap.returnValue = false;
    }
  }
};

isNumChange = function() {
  var cart, hap, isNum, prev, value;
  console.log("isNumChange");
  hap = window.event || e;
  isNum = false;
  value = this.value;
  prev = this.defaultValue;
  if (isNormalInteger(value) === false) {
    this.setAttribute("style", "background-color : #ffaaaa");
    this.value = "";
    return this.focus();
  } else {
    this.setAttribute("style", "background-color : #ffffff");
    cart = isNumChange.cart;
    return cart.setItemQuantity(this.id, this.value);
  }
};

bindRowFields = function(cart, itemRows) {
  var i, len, qtyField, row, rowArray, _i, _ref, _results;
  console.log("bindRF rows", itemRows);
  len = itemRows.length;
  rowArray = [len];
  _results = [];
  for (i = _i = 0, _ref = len - 1; _i <= _ref; i = _i += 1) {
    row = itemRows[i];
    qtyField = row.getElementsByClassName("quantity")[0];
    bind(qtyField, "keypress", isNumKey);
    isNumChange["cart"] = cart;
    _results.push(bind(qtyField, "change", isNumChange));
  }
  return _results;
};

parentDivName = "";

loadCart = function(divName) {
  var cart, element;
  cart = new Cart();
  element = cart.getElement();
  parentDivName = divName;
  document.getElementById(divName).appendChild(element);
  bindRowFields(cart, document.getElementsByClassName("itemRow"));
  return cart;
};

Cart = function() {
  var CART, TEST_TOTAL, addItem, getElement, initElement, makeRow, myElement, pullCart, pushCart, refresh, setItemQuantity;
  CART = "cart";
  myElement = null;
  pullCart = function() {
    var localCart;
    localCart = getLocalObject(CART);
    if (localCart != null) {
      return localCart;
    } else {
      return {};
    }
  };
  pushCart = function(cartObj) {
    return setLocalObject(CART, cartObj);
  };
  addItem = function(id, name, model, info, price) {
    var cartItem, cartObj, numInCart, qty;
    cartObj = pullCart();
    console.log("ADD ITEM cart ", pullCart());
    cartItem = cartObj[id];
    if (!(cartItem != null)) {
      cartItem = {};
      qty = 1;
      cartItem["obj"] = {
        id: id,
        name: name,
        model: model,
        info: info,
        price: price
      };
      cartItem["qty"] = qty;
    } else {
      console.log(cartItem.qty);
      numInCart = Number(cartItem.qty);
      cartItem["qty"] = numInCart + 1;
    }
    cartObj[id] = cartItem;
    console.log("ITEM == ", cartItem);
    pushCart(cartObj);
    refresh();
    return cartObj;
  };
  setItemQuantity = function(id, quantity) {
    var cartObj;
    cartObj = pullCart();
    if (cartObj[id] != null) {
      if (Number(quantity) === 0) {
        delete cartObj[id];
      } else {
        cartObj[id][qty] = Number(quantity);
      }
    } else {
      cartObj[id]["obj"] = {
        name: name,
        model: model,
        info: info,
        price: price
      };
      cartObj[id]["qty"] = quantity;
    }
    pushCart(cartObj);
    refresh();
    return cartObj;
  };
  makeRow = function(obj, quantity) {
    var qtyFieldSize, td1, td2, td3, td4, td5, tr;
    console.log(obj.id);
    console.log(obj.name);
    console.log(obj.model);
    console.log(obj.info);
    console.log(obj.price);
    tr = document.createElement("TR");
    tr.setAttribute("ID", "tr" + obj.id);
    tr.setAttribute("CLASS", "itemRow");
    td1 = document.createElement("TD");
    td1.appendChild(document.createTextNode(obj.id));
    tr.appendChild(td1);
    td2 = document.createElement("TD");
    td2.appendChild(document.createTextNode(obj.name));
    tr.appendChild(td2);
    td3 = document.createElement("TD");
    td3.appendChild(document.createTextNode(obj.model));
    tr.appendChild(td3);
    td4 = document.createElement("TD");
    td4.appendChild(document.createTextNode(formatCurrency(obj.price)));
    tr.appendChild(td4);
    td5 = document.createElement("INPUT");
    qtyFieldSize = "3";
    td5.setAttribute("SIZE", qtyFieldSize);
    td5.setAttribute("MAXLENGTH", qtyFieldSize);
    td5.setAttribute("TYPE", "text");
    td5.setAttribute("CLASS", "quantity");
    td5.setAttribute("ID", obj.id);
    td5.setAttribute("VALUE", quantity);
    tr.appendChild(td5);
    return tr;
  };
  TEST_TOTAL = 250.00;
  initElement = function() {
    var itemkey, obj, pc, qty, subtotalRow, table, tableBody, tableFoot, tdCost, tdWord;
    console.log("INIT ELEMENT");
    table = document.createElement("TABLE");
    table.setAttribute("NAME", "cartTable");
    tableBody = document.createElement("TBODY");
    tableFoot = document.createElement("TFOOT");
    table.appendChild(tableBody);
    table.appendChild(tableFoot);
    pc = pullCart();
    for (itemkey in pc) {
      obj = pc[itemkey]["obj"];
      qty = pc[itemkey]["qty"];
      tableBody.appendChild(makeRow(obj, qty));
    }
    subtotalRow = document.createElement("TR");
    tdWord = document.createElement("TD");
    tdWord.colspan = "4";
    tdWord.align = "right";
    tdWord.appendChild(document.createTextNode("Subtotal"));
    tdCost = document.createElement("TD");
    tdCost.appendChild(document.createTextNode(formatCurrency(TEST_TOTAL)));
    subtotalRow.appendChild(tdWord);
    subtotalRow.appendChild(tdCost);
    tableFoot.appendChild(subtotalRow);
    myElement = table;
    return myElement;
  };
  getElement = function() {
    return (myElement != null) || initElement();
  };
  refresh = function() {
    if (myElement != null) {
      document.getElementById(parentDivName).removeChild(myElement);
      myElement = null;
      document.getElementById(parentDivName).appendChild(initElement());
      return bindRowFields(cart, document.getElementsByClassName("itemRow"));
    }
  };
  return {
    addItem: addItem,
    setItemQuantity: setItemQuantity,
    toString: toString,
    getElement: getElement
  };
};
