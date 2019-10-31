import argparse
import csv
import json
from datetime import datetime

def format(s):
    if s.find('"') != -1:
        return  '"' + s.replace("\"",  "\"\"") + '"'
    if s.find('\n') != -1:
        return  '"' + s + '"'
    if s.find(';') != -1:
        return  '"' + s + '"'
    return s
    
def transform_dim_applications(extract_directory, transform_directory):
    print ("Transform", "DIM_APPLICATIONS")
    ofile = transform_directory + "\\DIM_APPLICATIONS.sql"
    f = open(ofile, "w", encoding="utf-8")

    with open(extract_directory+'\\DIM_APPLICATIONS.csv') as csv_file:
    
        f.write("DROP TABLE IF EXISTS :schema.DIM_APPLICATIONS CASCADE;\n");
        f.write("CREATE TABLE :schema.DIM_APPLICATIONS\n");
        f.write("(\n");
        csv_reader = csv.reader(csv_file, delimiter=';')
        skip = True
        for row in csv_reader:
            if skip:
                skip = False
                comma = ""
                for p in row:
                    f.write("\"" + p + "\" ")
                    f.write("boolean" if p.startswith("Technology") else "text")
                    f.write(",\n")
                f.write("CONSTRAINT DIM_APPLICATIONS_PKEY PRIMARY KEY (APPLICATION_NAME)\n");
                f.write(");\n")
                f.write("COPY :schema.DIM_APPLICATIONS (\""  + "\",\"".join(row) + "\") FROM stdin WITH (delimiter ';', format CSV, null 'null');\n")        
                continue
            line = ";".join([format(cell) for cell in row])
            f.write(line)
            f.write("\n")
        f.write("\\.\n")
        f.close()

def transform_dim_quality_standards(extract_directory, transform_directory):
    print ("Transform", "DIM_QUALITY_STANDARDS")
    ofile = transform_directory + "\\DIM_QUALITY_STANDARDS.sql"
    f = open(ofile, "w", encoding="utf-8")

    with open(extract_directory+'\\DIM_QUALITY_STANDARDS.csv') as csv_file:
    
        f.write("DROP TABLE IF EXISTS :schema.DIM_QUALITY_STANDARDS CASCADE;\n");
        f.write("CREATE TABLE :schema.DIM_QUALITY_STANDARDS\n");
        f.write("(\n");        
        f.write("METRIC_ID INT,\n");
        f.write("RULE_NAME TEXT,\n");

        csv_reader = csv.reader(csv_file, delimiter=';')
        skip = True
        columns = ["METRIC_ID", "RULE_NAME"]
        for row in csv_reader:
            if skip:
                skip = False
                # End writing the header
                comma = ""
                for i,p in enumerate(row):
                    if i <= 1: 
                        continue
                    column_name = p.replace("-","_")
                    columns.append(column_name)
                    f.write(column_name)
                    f.write(" BOOLEAN,\n")
                f.write("CONSTRAINT DIM_QUALITY_STANDARDS_PKEY PRIMARY KEY (METRIC_ID)\n");
                f.write(");\n")
                f.write("COPY :schema.DIM_QUALITY_STANDARDS ("  + ",".join(columns) + ") FROM stdin WITH (delimiter ';', format CSV, null 'null');\n")        
                continue
            # Write the body
            line = ";".join([format(cell) for cell in row])
            f.write(line)
            f.write("\n")
        f.write("\\.\n")
        f.close()

def transform(extract_directory, transform_directory, table_name):
    print ("Transform", table_name)
    ofile = transform_directory + "\\" + table_name + ".sql"
    f = open(ofile, "w", encoding="utf-8")

    with open(extract_directory+"\\" + table_name + ".csv") as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=';')
        skip = True
        for row in csv_reader:
            if skip:
                skip = False
                f.write("COPY :schema." + table_name + "("  + ",".join(row) + ") FROM stdin WITH (delimiter ';', format CSV, null 'null');\n")        
                continue
            line = ";".join([format(cell) for cell in row])
            f.write(line)
            f.write("\n")
        f.write("\\.\n")
        f.close()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(formatter_class=argparse.RawDescriptionHelpFormatter, description="Transform Extract CSV iles into SQL statements for PostgreSQL")
    parser.add_argument("-i", "--extract", dest="extract_directory", action="store", help="set input extract directory")
    parser.add_argument("-o", "--transform", dest="transform_directory", action="store", help="set output transform directory")
    args = parser.parse_args()
    transform_dim_applications(args.extract_directory, args.transform_directory)    
    transform_dim_quality_standards(args.extract_directory, args.transform_directory)    
    transform(args.extract_directory, args.transform_directory, "DIM_RULES")
    transform(args.extract_directory, args.transform_directory, "DIM_SNAPSHOTS")
    transform(args.extract_directory, args.transform_directory, "APP_VIOLATIONS_MEASURES")
    transform(args.extract_directory, args.transform_directory, "APP_SIZING_MEASURES")
    transform(args.extract_directory, args.transform_directory, "APP_FUNCTIONAL_SIZING_MEASURES")    
    transform(args.extract_directory, args.transform_directory, "APP_HEALTH_MEASURES")        
    transform(args.extract_directory, args.transform_directory, "APP_SIZING_EVOLUTION")    
    transform(args.extract_directory, args.transform_directory, "APP_FUNCTIONAL_SIZING_EVOLUTION")
    transform(args.extract_directory, args.transform_directory, "APP_HEALTH_EVOLUTION")
    transform(args.extract_directory, args.transform_directory, "MOD_VIOLATIONS_MEASURES")    
    transform(args.extract_directory, args.transform_directory, "MOD_SIZING_MEASURES")
    transform(args.extract_directory, args.transform_directory, "MOD_HEALTH_MEASURES")        
    transform(args.extract_directory, args.transform_directory, "MOD_SIZING_EVOLUTION")    
    transform(args.extract_directory, args.transform_directory, "MOD_HEALTH_EVOLUTION")

