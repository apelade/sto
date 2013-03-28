var Catalog, catalog, initCat;

initCat = function() {
  var acatalog;
  acatalog = new Catalog();
  acatalog.rebind();
  return acatalog;
};

Catalog = function() {
  var addItemDiv, addItems, button, cols, fetchPage, limit, page, pageField, parent, rebind, resultsDiv, row;
  page = -1;
  limit = 10;
  parent = document.getElementById("catalogDiv");
  row = document.createElement("DIV");
  row.setAttribute("class", "row-fluid");
  cols = document.createElement("DIV");
  cols.setAttribute("class", "span12");
  cols.setAttribute("align", "center");
  parent.appendChild(row);
  row.appendChild(cols);
  cols.appendChild(document.createTextNode(" Page:"));
  pageField = document.createElement("INPUT");
  pageField.setAttribute("TYPE", "text");
  pageField.setAttribute("ID", "pageField");
  cols.appendChild(pageField);
  button = document.createElement("INPUT");
  button.setAttribute("TYPE", "button");
  button.setAttribute("VALUE", "Next Ten");
  button.setAttribute("ID", "nextTenButton");
  cols.appendChild(button);
  resultsDiv = document.createElement("DIV");
  parent.appendChild(resultsDiv);
  addItemDiv = function(item, row) {
    var itemBtn, itemDiv, itemInfo, itemName, itemPrice;
    itemDiv = document.createElement("DIV");
    itemDiv.setAttribute("class", "span4");
    row.appendChild(itemDiv);
    itemName = document.createElement("H2");
    itemName.appendChild(document.createTextNode(item.name));
    itemPrice = document.createTextNode(formatCurrency(item.price));
    itemInfo = document.createTextNode(item.info);
    itemBtn = document.createElement("INPUT");
    itemBtn.setAttribute("type", "button");
    itemBtn.setAttribute("value", "Buy " + item._id);
    itemBtn.setAttribute("name", item._id);
    itemBtn.setAttribute("class", "catItemBuyButton");
    itemBtn.item = item;
    itemDiv.appendChild(itemName);
    itemDiv.appendChild(document.createElement("BR"));
    itemDiv.appendChild(itemPrice);
    itemDiv.appendChild(document.createElement("BR"));
    itemDiv.appendChild(itemInfo);
    itemDiv.appendChild(document.createElement("BR"));
    return itemDiv.appendChild(itemBtn);
  };
  addItems = function(items) {
    var i, item, _i, _len, _results;
    resultsDiv.innerHTML = "";
    row = null;
    _results = [];
    for (i = _i = 0, _len = items.length; _i < _len; i = ++_i) {
      item = items[i];
      if (i === 0 || i % 3 === 0) {
        row = document.createElement("DIV");
        row.setAttribute("class", "row-fluid");
        resultsDiv.appendChild(row);
      }
      _results.push(addItemDiv(item, row));
    }
    return _results;
  };
  fetchPage = function() {
    return $.get("/nextTen", {
      page: page,
      limit: limit
    }, function(data) {
      var msg;
      if (data !== "[]") {
        pageField.value = page;
        addItems(JSON.parse(data));
      } else {
        if (page === 0) {
          msg = "Got nothing on page zero, giving up";
          console.log(msg);
          return msg;
        } else {
          page = 0;
          fetchPage();
        }
      }
      return $('input[class=catItemBuyButton]').click(function(event) {
        var eti;
        if (event.target.item != null) {
          eti = event.target.item;
          return cart.addItem(eti._id, eti.name, eti.model, eti.info, eti.price);
        }
      });
    });
  };
  rebind = function() {
    $("#pageField").change(function() {
      if (page !== Number(pageField.value)) {
        page = Number(pageField.value);
        return fetchPage();
      }
    });
    return $("#nextTenButton").click(function() {
      page++;
      return fetchPage();
    });
  };
  return {
    rebind: rebind
  };
};

catalog = initCat();
