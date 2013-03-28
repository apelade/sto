var Cart, bindRowFields, cart, initCart, isNumChange, isNumKey, parentDivName, purgeCart;

purgeCart = function() {
  return localStorage.setItem("cart", JSON.stringify({}));
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

initCart = function() {
  var acart, element;
  acart = new Cart();
  element = acart.getElement();
  parentDivName = "cartDiv";
  document.getElementById(parentDivName).appendChild(element);
  bindRowFields(acart, document.getElementsByClassName("itemRow"));
  return acart;
};

Cart = function() {
  var CART, addItem, getElement, initElement, makeRow, myElement, pullCart, pushCart, refresh, setItemQuantity;
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
        cartObj[id]["qty"] = Number(quantity);
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
    var lineTotal, qtyField, qtyFieldSize, td1, td2, td3, td4, td5, td6, tr;
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
    td4.align = "left";
    tr.appendChild(td4);
    td5 = document.createElement("TD");
    qtyField = document.createElement("INPUT");
    qtyFieldSize = "3";
    qtyField.setAttribute("SIZE", qtyFieldSize);
    qtyField.setAttribute("MAXLENGTH", qtyFieldSize);
    qtyField.setAttribute("TYPE", "text");
    qtyField.setAttribute("CLASS", "quantity");
    qtyField.setAttribute("ID", obj.id);
    qtyField.setAttribute("VALUE", quantity);
    td5.appendChild(qtyField);
    tr.appendChild(td5);
    td6 = document.createElement("TD");
    lineTotal = Number(obj.price) * Number(quantity);
    td6.appendChild(document.createTextNode(formatCurrency(lineTotal)));
    td6.align = "right";
    tr.appendChild(td6);
    return tr;
  };
  initElement = function() {
    var itemkey, obj, pc, qty, subtotalRow, table, tableBody, tableFoot, tdCost, tdWord, totalCost, totalQty;
    totalCost = 0;
    totalQty = 0;
    console.log("INIT ELEMENT");
    table = document.createElement("TABLE");
    table.setAttribute("NAME", "cartTable");
    tableBody = document.createElement("TBODY");
    tableFoot = document.createElement("TFOOT");
    table.appendChild(tableBody);
    pc = pullCart();
    for (itemkey in pc) {
      obj = pc[itemkey]["obj"];
      qty = pc[itemkey]["qty"];
      if ((obj != null) && (qty != null) && (obj.price != null)) {
        tableBody.appendChild(makeRow(obj, qty));
        totalCost += Number(qty) * Number(obj.price);
        totalQty += Number(qty);
      }
    }
    subtotalRow = document.createElement("TR");
    tdWord = document.createElement("TD");
    tdWord.setAttribute("colspan", "5");
    tdWord.setAttribute("align", "right");
    tdWord.appendChild(document.createTextNode(" " + totalQty + " items :  "));
    tdCost = document.createElement("TD");
    tdCost.setAttribute("align", "left");
    tdCost.appendChild(document.createTextNode(formatCurrency(totalCost)));
    subtotalRow.appendChild(tdWord);
    subtotalRow.appendChild(tdCost);
    tableBody.appendChild(subtotalRow);
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

cart = {};

$(document).ready(function() {
  return cart = initCart();
});
