import xml.dom.minidom
import sys

def build_markdown():
    doc = xml.dom.minidom.parse("DataDictionary.xml");
    tables = doc.getElementsByTagName("table")

    for table in tables:
        name = table.getElementsByTagName("name")[0].firstChild.data
        print ("- [" + name + "](#" + name + ")")
    
    print()
    for table in tables:
        name = table.getElementsByTagName("name")[0].firstChild.data
        print ("### " + name)
        description = table.getElementsByTagName("description")[0].firstChild.data
        print (description)
        columns = table.getElementsByTagName("column")
        if columns.length == 0:
            continue
        print ("```")
        
        description_length = 47 if name == "APP_FUNCTIONAL_SIZING_EVOLUTION" else 37

        print ("COLUMN" + (" " * (description_length - 6))  + "| TYPE     | DESCRIPTION")
        print (("-" * description_length) + "+----------+------------")
        for column in columns:
            col_type = column.attributes["type"].value
            col_name = column.getElementsByTagName("name")[0].firstChild.data
            col_description = column.getElementsByTagName("description")[0].firstChild.data
            lines = col_description.split("\n")
            print(col_name.ljust(description_length) + "|" + (" " + col_type).ljust(10) + "| " + lines[0])
            for line in lines[1:]:
                print("                                     |          | " + line)
        print ("```")
        print("")

def build_sql():
    doc = xml.dom.minidom.parse("DataDictionary.xml");
    tables = doc.getElementsByTagName("table")
    for table in tables:
        name = table.getElementsByTagName("name")[0].firstChild.data
        description = table.getElementsByTagName("description")[0].firstChild.data
        table_type = table.attributes["type"].value        
        if table_type != "table":
            continue
        print ("COMMENT ON TABLE :schema." + name + " IS '" + description.replace("'","''") + "';")
        columns = table.getElementsByTagName("column")
        if columns.length == 0:
            continue
        for column in columns:
            col_type = column.attributes["type"].value
            col_name = column.getElementsByTagName("name")[0].firstChild.data
            col_description = column.getElementsByTagName("description")[0].firstChild.data
            print ("COMMENT ON COLUMN :schema." + name + "." + col_name + " IS '" + col_description.replace("'","''") + "';")
        print()
    
if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: " + sys.argv[0] + " sql|markdown")
        sys.exit(1)
    elif sys.argv[1] == "sql":
        build_sql()
    elif sys.argv[1] == "markdown":
        build_markdown()
    else:
        sys.exit(1)
      
  
