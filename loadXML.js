//example file from https://developer.mozilla.org/en-US/docs/Web/XSLT/XSLT_JS_interface_in_Gecko/Basic_Example

var xslStylesheet;

var xmlDoc;
var file;
var fragment;

function Init(file){
  var xsltProcessor = new XSLTProcessor();
  // load the xslt file, example1.xsl
  var myXMLHTTPRequest = new XMLHttpRequest();
  myXMLHTTPRequest.open("GET", "wagenreihung_fragment.xsl", false);
  myXMLHTTPRequest.send(null);

  xslStylesheet = myXMLHTTPRequest.responseXML;
  xsltProcessor.importStylesheet(xslStylesheet);


  // load the xml file, example1.xml
  myXMLHTTPRequest = new XMLHttpRequest();
  myXMLHTTPRequest.open("GET", file, false);
  myXMLHTTPRequest.send(null);

  xmlDoc = myXMLHTTPRequest.responseXML;

  fragment = xsltProcessor.transformToFragment(xmlDoc, document);

  document.getElementById("Wagenreihung").innerHTML = "";

  document.getElementById("Wagenreihung").appendChild(fragment);
  document.getElementById("Bahnhöfe").style.display = "none";
  document.getElementById("back-to-overview").style.display = "block";
}

function hide_wgr(){
  document.getElementById("Wagenreihung").innerHTML = "";
  document.getElementById("Bahnhöfe").style.display = "block";
  document.getElementById("back-to-overview").style.display = "none";
}
