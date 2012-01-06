#import('dart:html');


//A list of elements
interface View {
  List<Element> elements;
}

//a generic table that can bind to some data. 
class Grid implements View { 
  TableElement _table;
  List<String> fields;
  List dataItems;
  var dataMappingFunction;
  
  Grid() {
    _table = new Element.tag("table");
    _table.border="1";
    
    fields = new List<String>();
  } 
  
  //returns a list of elements to be added to the DOM.
  //implements View interface
  List<Element> get elements() {
    List<Element> result = new List<Element>();

    _bindHeader();
    _bindData();
    
    result.add(_table);
    
    return result;
  }
  
  //bind the header row
  _bindHeader() {
    TableRowElement row = new Element.tag("tr");
    fields.forEach((fieldName) {
      TableCellElement cell = new Element.tag("td");
      cell.text = fieldName;
  
      row.nodes.add(cell);
    });
    


    _table.nodes.add(row);
  }
  
  //bind the data items into the table.
  _bindData() {
    dataItems.forEach((dataItem) {
      TableRowElement row = new Element.tag("tr");
      
      fields.forEach((field) {
        //get the field value from the Data Mapping function.
        var fieldValue = dataMappingFunction(field, dataItem);
        
        //set the fieldValue and add to the current row.
        TableCellElement cell = new Element.tag("td");
        cell.text = fieldValue;
        row.nodes.add(cell);
      });
      
      _table.nodes.add(row);
    });
  }
  
} 




//Our Data class
class SomeData {
  var name;
  var addr1;
  var city;  
  
  SomeData(this.name, this.addr1, this.city) {}
}


//create some mock data
List<SomeData> getMockData() {
  List<SomeData> data = new List<SomeData>();
  data.add(new SomeData("Chris", "A Street", "Maidstone"));
  data.add(new SomeData("Bob", "The Road", "London"));
  data.add(new SomeData("Tom", "The Town", "Brum"));
  return data;
}



//A utility function to add a view to the document, or to other views elements.
void addView(View view, [Element parent]) {
  if (parent == null) {
    parent = document.body;
  }
  
  parent.nodes.addAll(view.elements);
}



//main function.
void main() {
  Grid grid = new Grid();
  
  //add the fields (columns)
  grid.fields.add("name");
  grid.fields.add("addr1");
  grid.fields.add("city");
  

  //add the data items
  grid.dataItems = getMockData();
  
  //anonymous function to map from a data field name to a data item value.
  grid.dataMappingFunction = (fieldName, dataItem) {
    //would be ideal to use reflection!
    if (fieldName == "name") {
      return dataItem.name;
    }
    
    if (fieldName == "addr1") {
      return dataItem.addr1;
    }
    
    if (fieldName == "city") {
      return dataItem.city;
    }
  };
  
 
  print("before add");
  //add the grid - this will cause the grid table element to be built and added to the DOM
  addView(grid);
}
