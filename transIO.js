var chosen =[];
var movedTo=[];

var selectedElement = 0;
var currentX = 0;
var currentY = 0;
var origX = 0;
var origY = 0;
var currentMatrix = 0;

var svg = document.querySelector("svg");
var pt  = svg.createSVGPoint();

//TRANSFORM

// selectElement 
function selectElement(evt) {
  selectedElement = evt.target;
  currentX = evt.clientX;
  currentY = evt.clientY;
  origX=evt.clientX;
  origY=evt.clientY;
  //alert("current point=c(" + currentX + ","+ currentY +")" );
  currentMatrix = selectedElement.getAttributeNS(null, "transform").slice(7,-1).split(' ');
  for(var i=0; i<currentMatrix.length; i++) {
    currentMatrix[i] = parseFloat(currentMatrix[i]);
  }
  //add eventattrs to element
  selectedElement.parentNode.appendChild( selectedElement ); //brings to top
  selectedElement.setAttributeNS(null, "onmousemove", "moveElement(evt)");
  selectedElement.setAttributeNS(null, "onmouseout", "deselectElement(evt)");
  selectedElement.setAttributeNS(null, "onmouseup",  "deselectElement(evt)");
}

// translation of an element
function moveElement(evt) {
  if(selectedElement!=0){ // this shouldn't be necessary
    var dx = evt.clientX - currentX;
    var dy = evt.clientY - currentY;
    currentMatrix[4] += dx;
    currentMatrix[5] += dy;

    selectedElement.setAttributeNS(null, "transform", "matrix(" + currentMatrix.join(' ') + ")");
    currentX = evt.clientX;
    currentY = evt.clientY;
  }
  
}

// deselect that element
function deselectElement(evt) {
  if(selectedElement != 0){
    var movedByX = evt.clientX - origX;
    var movedByY = evt.clientY - origY;
    // alert("deselecting1")
    
    var tid = selectedElement.getAttribute("tid");
    //alert("tid=" + tid);
    //currentMatrix = selectedElement.getAttributeNS(null, "transform");
    //currentMatrix = selectedElement.getAttributeNS(null, "transform").slice(7,-1).split(' ');
   // alert("currentMatrix="  + currentMatrix);
    
    var currentMatrixAsString="c(" + currentMatrix.join(',') + ")";
   // alert("currentMatrixAsString=" +currentMatrixAsString);
    chosen=["trans", currentMatrixAsString, tid];
    //alert("chosen=" + chosen[1] + chosen[2]+ chosen[3]);
    Shiny.onInputChange("mydata",chosen);
    
    selectedElement.removeAttributeNS(null, "onmousemove");
    selectedElement.removeAttributeNS(null, "onmouseout");
    selectedElement.removeAttributeNS(null, "onmouseup");
    selectedElement = 0;
    
  }
}
