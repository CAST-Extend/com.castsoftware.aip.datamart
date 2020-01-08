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

def transform_dim_applications(mode, extract_directory, transform_directory):
    print ("Transform", "DIM_APPLICATIONS")
    ofile = transform_directory + "\\DIM_APPLICATIONS.sql"
    f = open(ofile, "w", encoding="utf-8")

    with open(extract_directory+'\\DIM_APPLICATIONS.csv') as csv_file:

        if mode in ["refresh", "refresh_measures"]:
            f.write("TRUNCATE TABLE :schema.DIM_APPLICATIONS CASCADE;\n")
        elif mode == "install":
            # Begin CREATE TABLE STATEMENT
            f.write("DROP TABLE IF EXISTS :schema.DIM_APPLICATIONS CASCADE;\n");
            f.write("CREATE TABLE :schema.DIM_APPLICATIONS\n");
            f.write("(\n");

        csv_reader = csv.reader(csv_file, delimiter=';')
        skip = True
        for row in csv_reader:
            if skip:
                skip = False
                if mode == "install":
                    comma = ""
                    for p in row:
                        f.write("\"" + p + "\" ")
                        f.write("boolean" if p.startswith("Technology") else "text")
                        f.write(",\n")
                    f.write("CONSTRAINT DIM_APPLICATIONS_PKEY PRIMARY KEY (APPLICATION_NAME)\n");
                    f.write(");\n")
                    # End CREATE TABLE STATEMENT
                f.write("COPY :schema.DIM_APPLICATIONS (\""  + "\",\"".join(row) + "\") FROM stdin WITH (delimiter ';', format CSV, null 'null');\n")
                continue
            line = ";".join([format(cell) for cell in row])
            f.write(line)
            f.write("\n")
        f.write("\\.\n")
        f.close()

def transform(mode, extract_directory, transform_directory, table_name):
    print ("Transform", table_name)
    ofile = transform_directory + "\\" + table_name + ".sql"
    f = open(ofile, "w", encoding="utf-8")

    if mode in ["refresh", "refresh_measures"]:
        f.write("TRUNCATE TABLE :schema." + table_name + " CASCADE;\n")

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

def transform_details(mode, extract_directory, transform_directory, table):
    table_name = table["name"]
    if mode != 'replace_details': 
        transform (mode,  extract_directory, transform_directory, table_name)
        return

    print ("Transform", table_name)
    ofile = transform_directory + "\\" + table_name + ".sql"
    f = open(ofile, "w", encoding="utf-8")

    with open(extract_directory+"\\" + table_name + ".csv") as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=';')
        skip = True
        column_value = None
        column_name = table["column_name"]
        column_position = -1
        columns = None
        for row in csv_reader:
            if skip:
                skip = False
                columns = row
                for i,name in enumerate(row):
                    if name == column_name:
                        column_position = i
                        continue
                continue
            new_column_value = row[column_position] if column_name != 'object_id' else row[column_position].split(':')[0]
            #print(column_name, new_column_value, table_name, column_value)
            if column_value != new_column_value:
                if column_value != None:
                    f.write("\\.\n")                   
                if column_name == 'object_id':
                    f.write("DELETE FROM :schema." + table_name +  " WHERE " + column_name + " like '" + new_column_value + ":%' ;\n")
                else:
                    f.write("DELETE FROM :schema." + table_name +  " WHERE " + column_name + " = '" + new_column_value + "' ;\n")
                column_value = new_column_value
                f.write("COPY :schema." + table_name + "("  + ",".join(columns) + ") FROM stdin WITH (delimiter ';', format CSV, null 'null');\n")
            line = ";".join([format(cell) for cell in row])
            f.write(line)
            f.write("\n")
        if skip:
            f.write("\\.\n")
        f.close()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(formatter_class=argparse.RawDescriptionHelpFormatter, description="Transform Extract CSV iles into SQL statements for PostgreSQL")
    parser.add_argument("-i", "--extract", dest="extract_directory", action="store", help="set input extract directory")
    parser.add_argument("-o", "--transform", dest="transform_directory", action="store", help="set output transform directory")
    parser.add_argument("-m", "--mode", dest="mode", action="store", help="set generation mode: refresh, install, append_details, replace_details, refresh_measures")
    parser.add_argument("-d", "--domain", dest="domain", action="store", help="the domain to transform")
    args = parser.parse_args()

    if args.mode in ['refresh', 'install', 'refresh_measures']:
        transform_dim_applications(args.mode, args.extract_directory, args.transform_directory)
        transform(args.mode, args.extract_directory, args.transform_directory, "DIM_RULES")
        transform(args.mode, args.extract_directory, args.transform_directory, "DIM_SNAPSHOTS")
        transform(args.mode, args.extract_directory, args.transform_directory, "APP_VIOLATIONS_MEASURES")
        transform(args.mode, args.extract_directory, args.transform_directory, "APP_SIZING_MEASURES")
        transform(args.mode, args.extract_directory, args.transform_directory, "APP_FUNCTIONAL_SIZING_MEASURES")
        transform(args.mode, args.extract_directory, args.transform_directory, "APP_HEALTH_MEASURES")
        transform(args.mode, args.extract_directory, args.transform_directory, "APP_SIZING_EVOLUTION")
        transform(args.mode, args.extract_directory, args.transform_directory, "APP_FUNCTIONAL_SIZING_EVOLUTION")
        transform(args.mode, args.extract_directory, args.transform_directory, "APP_HEALTH_EVOLUTION")
        transform(args.mode, args.extract_directory, args.transform_directory, "MOD_VIOLATIONS_MEASURES")
        transform(args.mode, args.extract_directory, args.transform_directory, "MOD_SIZING_MEASURES")
        transform(args.mode, args.extract_directory, args.transform_directory, "MOD_HEALTH_MEASURES")
        transform(args.mode, args.extract_directory, args.transform_directory, "MOD_SIZING_EVOLUTION")
        transform(args.mode, args.extract_directory, args.transform_directory, "MOD_HEALTH_EVOLUTION")
        transform(args.mode, args.extract_directory, args.transform_directory, "STD_RULES")
        transform(args.mode, args.extract_directory, args.transform_directory, "STD_DESCRIPTIONS")
    tables = []
    if args.mode != 'refresh_measures':
        tables = [
                    {"name":"SRC_OBJECTS", "column_name":"application_name"},
                    {"name":"SRC_TRANSACTIONS", "column_name":"application_name"},
                    {"name":"SRC_MOD_OBJECTS", "column_name":"application_name"},
                    {"name":"SRC_TRX_OBJECTS", "column_name":"object_id"},
                    {"name":"SRC_VIOLATIONS", "column_name":"object_id"},
                    {"name":"SRC_HEALTH_IMPACTS", "column_name":"object_id"},
                    {"name":"USR_EXCLUSIONS", "column_name":"application_name"},
                    {"name":"USR_ACTION_PLAN", "column_name":"application_name"}
                ]

    for table in tables:
        transform_details(args.mode, args.extract_directory, args.transform_directory, table)
