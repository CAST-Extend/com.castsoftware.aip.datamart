import xml.dom.minidom
import sys

def build_markdown(output_path):
    f = open(output_path, "w", encoding="utf-8")
    doc = xml.dom.minidom.parse("data_dictionary.xml");
    tablesElements = doc.getElementsByTagName("table")
    tablesDict = {}
    tablesNames = []
    for tableElement in tablesElements:
        tableName = tableElement.getElementsByTagName("name")[0].firstChild.data
        tablesDict[tableName] = tableElement
        tablesNames.append(tableName)
    tablesNames = sorted(tablesNames)

    f.write("## Data Dictionary\n")

    for tableName in tablesNames:
        f.write ("- [" + tableName + "](#" + tableName + ")\n")

    f.write("\n")
    for tableName in tablesNames:
        f.write ("### " + tableName + "\n")
        tableElement = tablesDict[tableName]
        description = tableElement.getElementsByTagName("description")[0].firstChild.data
        f.write (description + "\n")
        columns = tableElement.getElementsByTagName("column")
        if columns.length == 0:
            continue
        f.write ("```\n")

        description_length = 47 if tableName == "APP_FUNCTIONAL_SIZING_EVOLUTION" else 37

        f.write ("COLUMN" + (" " * (description_length - 6))  + "| TYPE     | DESCRIPTION\n")
        f.write (("-" * description_length) + "+----------+------------\n")
        for column in columns:
            col_type = column.attributes["type"].value
            col_name = column.getElementsByTagName("name")[0].firstChild.data
            col_description = column.getElementsByTagName("description")[0].firstChild.data
            lines = col_description.split("\n")
            print(col_name.ljust(description_length) + "|" + (" " + col_type).ljust(10) + "| " + lines[0]+"\n")
            for line in lines[1:]:
                f.write("                                     |          | \n" + line)
        f.write("```\n")
    f.write("\n")
    f.close()

def build_sql(output_path):
    f = open(output_path, "w", encoding="utf-8")
    doc = xml.dom.minidom.parse("data_dictionary.xml");
    tablesElements = doc.getElementsByTagName("table")
    for tableElement in tablesElements:
        name = tableElement.getElementsByTagName("name")[0].firstChild.data
        description = tableElement.getElementsByTagName("description")[0].firstChild.data
        table_type = tableElement.attributes["type"].value
        if table_type != "table":
            continue
        f.write ("COMMENT ON TABLE :schema." + name + " IS '" + description.replace("'","''") + "';\n")
        columns = tableElement.getElementsByTagName("column")
        if columns.length == 0:
            continue
        for column in columns:
            col_type = column.attributes["type"].value
            col_name = column.getElementsByTagName("name")[0].firstChild.data
            col_description = column.getElementsByTagName("description")[0].firstChild.data
            f.write ("COMMENT ON COLUMN :schema." + name + "." + col_name + " IS '" + col_description.replace("'","''") + "';\n")
    f.write("\n")
    f.close()

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: " + sys.argv[0] + " sql|markdown {output_path}")
        sys.exit(1)
    elif sys.argv[1] == "sql":
        build_sql()
    elif sys.argv[1] == "markdown":
        build_markdown()
    else:
        sys.exit(1)


