import argparse
import csv
import json
import os
from datetime import datetime

#= Use comma delimiter for compliancy with Excel
DELIMITER=','
WARNINGS=False
ERRORS=False

def format(s):
    if s.find('"') != -1:
        return  '"' + s.replace("\"",  "\"\"") + '"'
    if s.find('\n') != -1:
        return  '"' + s + '"'
    if s.find(DELIMITER) != -1:
        return  '"' + s + '"'
    return s

quoted_identifier = os.environ.get('QUOTED_IDENTIFIER') != "OFF"

def format_column_name (id):
    if quoted_identifier:
        return ("\"" + id + "\"")
    return  (id.lower().replace(" ", "_"))

def transform_dim_applications(mode, extract_directory, transform_directory):
    global ERRORS
    print ("Transform", "DIM_APPLICATIONS")
    ofile = transform_directory + "\\DIM_APPLICATIONS.sql"
    f = open(ofile, "w", encoding="utf-8")

    with open(extract_directory+'\\DIM_APPLICATIONS.csv') as csv_file:

        if mode in ["refresh", "refresh_measures"]:
            f.write("TRUNCATE TABLE :schema.DIM_APPLICATIONS CASCADE;\n")
        elif mode == "install":
            # Begin CREATE TABLE STATEMENT
            f.write("DROP TABLE IF EXISTS :schema.DIM_APPLICATIONS CASCADE;\n")
            f.write("CREATE TABLE :schema.DIM_APPLICATIONS\n")
            f.write("(\n")

        csv_reader = csv.reader(csv_file, delimiter=DELIMITER)
        skip = True
        latestApplicationName = None
        for row in csv_reader:
            if skip:
                skip = False
                if mode == "install":
                    comma = ""
                    for p in row:
                        f.write(format_column_name(p))
                        f.write(" text") 
                        f.write(",\n")
                    f.write("CONSTRAINT DIM_APPLICATIONS_PKEY PRIMARY KEY (APPLICATION_NAME)\n")
                    f.write(");\n")
                    # End CREATE TABLE STATEMENT
                f.write("COPY :schema.DIM_APPLICATIONS ("  + ",".join(map(format_column_name,row)) + ") FROM stdin WITH (delimiter '" + DELIMITER +"', format CSV, null 'null');\n")
                continue
            line = DELIMITER.join([format(cell) for cell in row])
            if row[0] == latestApplicationName:
                print("\tDuplicate application name is not supported: " + row[0])
                ERRORS = True
            else:
                f.write(line)
                f.write("\n")      
            latestApplicationName = row[0]    
        f.write("\\.\n")
        f.close()

def transform(mode, extract_directory, transform_directory, table_name, nb_primary_columns):
    global WARNINGS
    print ("Transform", table_name)
    ofile = transform_directory + "\\" + table_name + ".sql"
    f = open(ofile, "w", encoding="utf-8")

    if mode in ["refresh", "refresh_measures"]:
        f.write("TRUNCATE TABLE :schema." + table_name + " CASCADE;\n")

    with open(extract_directory+"\\" + table_name + ".csv") as csv_file:

        csv_reader = csv.reader(csv_file, delimiter=DELIMITER)
        skip = True
        latestKeys = None
        for row in csv_reader:
            if skip:
                skip = False
                f.write("COPY :schema." + table_name + "("  + ",".join(row) + ") FROM stdin WITH (delimiter '" + DELIMITER + "', format CSV, null 'null');\n")
                continue
            line = DELIMITER.join([format(cell) for cell in row])
            # if nb of primary columns is set we check the rows with duplicated keys, only the first one is kept
            if nb_primary_columns != 0:
                keys = row[:nb_primary_columns]
                if keys == latestKeys:
                    print("\tSKIP duplicate key values: " + DELIMITER.join(keys))
                    WARNINGS=True
                else:
                    f.write(line)
                    f.write("\n")
                latestKeys = keys
            else:
                f.write(line)
                f.write("\n")
        f.write("\\.\n")
        f.close()

def transform_details(mode, extract_directory, transform_directory, table):
    global WARNINGS
    nb_primary_columns = table["nb_primary_columns"]
    table_name = table["name"]
    if mode != 'replace_details': 
        transform (mode,  extract_directory, transform_directory, table_name, 0)
        return

    print ("Transform", table_name)
    ofile = transform_directory + "\\" + table_name + ".sql"
    f = open(ofile, "w", encoding="utf-8")

    with open(extract_directory+"\\" + table_name + ".csv") as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=DELIMITER)
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
                f.write("COPY :schema." + table_name + "("  + ",".join(columns) + ") FROM stdin WITH (delimiter '" + DELIMITER + "', format CSV, null 'null');\n")
            line = DELIMITER.join([format(cell) for cell in row])
            # if nb of primary columns is set we check the rows with duplicated keys, only the first one is kept
            if nb_primary_columns != 0:
                keys = row[:nb_primary_columns]
                if keys == latestKeys:
                    print("\tSKIP duplicate key values: " + DELIMITER.join(keys))
                    WARNINGS = True
                else:
                    f.write(line)
                    f.write("\n")
                latestKeys = keys
            else:
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
        transform(args.mode, args.extract_directory, args.transform_directory, "DIM_RULES", 0)
        transform(args.mode, args.extract_directory, args.transform_directory, "DIM_OMG_RULES", 0)
        transform(args.mode, args.extract_directory, args.transform_directory, "DIM_CISQ_RULES", 0)        
        transform(args.mode, args.extract_directory, args.transform_directory, "DIM_SNAPSHOTS", 0)
        transform(args.mode, args.extract_directory, args.transform_directory, "APP_VIOLATIONS_MEASURES", 3)
        transform(args.mode, args.extract_directory, args.transform_directory, "APP_VIOLATION_EVOLUTION", 3)        
        transform(args.mode, args.extract_directory, args.transform_directory, "APP_SIZING_MEASURES", 1)
        transform(args.mode, args.extract_directory, args.transform_directory, "APP_TECHNO_SIZING_MEASURES", 2)
        transform(args.mode, args.extract_directory, args.transform_directory, "APP_FUNCTIONAL_SIZING_MEASURES", 1)
        transform(args.mode, args.extract_directory, args.transform_directory, "APP_HEALTH_SCORES", 2)
        transform(args.mode, args.extract_directory, args.transform_directory, "APP_SCORES", 2)
        transform(args.mode, args.extract_directory, args.transform_directory, "APP_SIZING_EVOLUTION", 1)
        transform(args.mode, args.extract_directory, args.transform_directory, "APP_FUNCTIONAL_SIZING_EVOLUTION", 1)
        transform(args.mode, args.extract_directory, args.transform_directory, "APP_HEALTH_EVOLUTION", 3)
        transform(args.mode, args.extract_directory, args.transform_directory, "MOD_VIOLATIONS_MEASURES", 4)
        transform(args.mode, args.extract_directory, args.transform_directory, "MOD_VIOLATIONS_EVOLUTION", 4)        
        transform(args.mode, args.extract_directory, args.transform_directory, "MOD_SIZING_MEASURES", 2)
        transform(args.mode, args.extract_directory, args.transform_directory, "MOD_TECHNO_SIZING_MEASURES", 3)
        transform(args.mode, args.extract_directory, args.transform_directory, "MOD_HEALTH_SCORES", 3)
        transform(args.mode, args.extract_directory, args.transform_directory, "MOD_SCORES", 3)        
        transform(args.mode, args.extract_directory, args.transform_directory, "MOD_SIZING_EVOLUTION", 3)
        transform(args.mode, args.extract_directory, args.transform_directory, "MOD_HEALTH_EVOLUTION", 4)
        transform(args.mode, args.extract_directory, args.transform_directory, "STD_RULES", 3)
        transform(args.mode, args.extract_directory, args.transform_directory, "STD_DESCRIPTIONS", 0)
    tables = []
    if args.mode != 'refresh_measures':
        tables = [
                    # set the column name that discriminates rows of a domain
                    # usually this is the application_name column, otherwise this is the object_id column
                    {"name":"SRC_OBJECTS", "column_name":"application_name", "nb_primary_columns": 2},
                    {"name":"SRC_TRANSACTIONS", "column_name":"application_name", "nb_primary_columns": 2},
                    {"name":"SRC_TRX_HEALTH_IMPACTS", "column_name":"application_name", "nb_primary_columns": 3},
                    {"name":"SRC_MOD_OBJECTS", "column_name":"application_name", "nb_primary_columns": 3},
                    {"name":"SRC_TRX_OBJECTS", "column_name":"object_id", "nb_primary_columns": 2},
                    {"name":"SRC_VIOLATIONS", "column_name":"object_id", "nb_primary_columns": 5},
                    {"name":"SRC_HEALTH_IMPACTS", "column_name":"object_id", "nb_primary_columns": 4},
                    {"name":"USR_EXCLUSIONS", "column_name":"application_name", "nb_primary_columns": 0},
                    {"name":"USR_ACTION_PLAN", "column_name":"application_name", "nb_primary_columns": 0}
                ]

    for table in tables:
        transform_details(args.mode, args.extract_directory, args.transform_directory, table)

    if WARNINGS:
        print("========================================================================")
        print("WARNING:")
        print("There are some duplicated rows for some snapshots")
        print("We recommend to reconsolidate these shapshots to clean up the database ")
        print("========================================================================")

    if ERRORS:
        print("========================================================================")    
        print("Errors found - Transform step is aborted")
        print("========================================================================")        
        exit(1);