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

let init = function() {
    xml=loadXMLDoc("restaurants.xml");
    xsl=loadXMLDoc("restaurants.xsl");

    // code for IE
if (window.ActiveXObject || xhttp.responseType == "msxml-document")
{
ex = xml.transformNode(xsl);
document.getElementById("example").innerHTML = ex;
}
// code for Chrome, Firefox, Opera, etc.
else if (document.implementation && document.implementation.createDocument)
{
    xsltProcessor = new XSLTProcessor();
    xsltProcessor.importStylesheet(xsl);
    resultDocument = xsltProcessor.transformToFragment(xml, document);
    document.getElementById("restaurants_table").replaceWith(resultDocument);
}}

$( document ).ready(init);