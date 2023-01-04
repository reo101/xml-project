function loadXMLDoc(dname) {
    if (window.XMLHttpRequest) {
        xhttp = new XMLHttpRequest();
    } else {
        xhttp = new ActiveXObject("Microsoft.XMLHTTP");
    }

    xhttp.open("GET", dname, false);
    xhttp.send();

    return xhttp.responseXML;
}

const RESTAURANTS_TABLES_DIV = "#restaurants_table";

var xml;
var xsl;
var xsltProcessor;

let init = function() {
    xml = loadXMLDoc("restaurants.xml");
    xsl = loadXMLDoc("restaurants.xsl");

    xsltProcessor = new XSLTProcessor();
    xsltProcessor.importStylesheet(xsl);

    generateTable();
};

var sortOn = "rating";
var sortOrder = "ascending";
var sortDataType = "number";

let getDataType = function(name) {
    return name == "rating" ? "number" : "text";
}

let toggleSortOrder = function() {
    sortOrder = sortOrder == "ascending" ? "descending" : "ascending";
};

let generateTable = function() {
    xsltProcessor.clearParameters();
    xsltProcessor.setParameter(null, "sortOn", sortOn);
    xsltProcessor.setParameter(null, "sortOrder", sortOrder);
    xsltProcessor.setParameter(null, "sortDataType", sortDataType);

    resultDocument = xsltProcessor.transformToFragment(xml, document);
    $(RESTAURANTS_TABLES_DIV).html(resultDocument);
};

let newSort = function(by) {
    if (by == sortOn) {
        toggleSortOrder();
    } else {
        sortOn = by;
        sortOrder = "ascending";
        sortDataType = getDataType(by);
    }

    console.log(by)
    console.log(sortOn);
    console.log(sortOrder);
    console.log(sortDataType);

    generateTable();
};

$(document).ready(init);
