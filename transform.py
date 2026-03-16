import argparse
import csv
import json
import os
from datetime import datetime

from CONFIG import DATAMART

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

quoted_identifier = os.environ.get('QUOTED_IDENTIFIER') != "OFF" # unset or ON by default
datapond = os.environ.get('EXTRACT_DATAPOND') == "ON"                    # unset or OFF by default

def format_column_name (id, output_format):
    if output_format == "datapond": 
        return "appname" if id == "application_name" else (id.lower().replace(" ", "_")) # no quoted identifier
    if quoted_identifier:
        return ("\"" + id + "\"")
    return  (id.lower().replace(" ", "_"))

def transform_dim_applications(mode, extract_directory, transform_directory, output_format):
    global ERRORS
    table_name = "DATAPOND_ORGANIZATION" if output_format == "datapond" else "DIM_APPLICATIONS"
    print ("Transform", table_name)
    ofile = os.path.join(transform_directory, table_name + ".sql")
    f = open(ofile, "w", encoding="utf-8")

    with open(os.path.join(extract_directory, 'DIM_APPLICATIONS.csv'), newline="", encoding="UTF-8") as csv_file:
        if mode in ["refresh", "hd-update"]:
            f.write("TRUNCATE TABLE :schema." + table_name + " CASCADE;\n")
        elif mode == "install":
            # Begin CREATE TABLE STATEMENT
            f.write("DROP TABLE IF EXISTS :schema." + table_name + " CASCADE;\n")
            f.write("CREATE TABLE :schema." + table_name + "\n")
            f.write("(\n")

        csv_reader = csv.reader(csv_file, delimiter=DELIMITER)
        skip = True
        latestApplicationName = None
        for row in csv_reader:
            if skip:
                skip = False
                if mode in ["refresh", "hd-update"]:
                    for p in row:
                        f.write("ALTER TABLE :schema." + table_name + " ADD COLUMN IF NOT EXISTS " + format_column_name(p, output_format) + " text;\n")
                elif mode == "install":                
                    for p in row:
                        f.write(format_column_name(p, output_format))
                        f.write(" text") 
                        f.write(",\n")
                    f.write("CONSTRAINT " + table_name + "_PKEY PRIMARY KEY (" + format_column_name("application_name", output_format) + ")\n")
                    f.write(");\n")
                    # End CREATE TABLE STATEMENT
                f.write("COPY :schema." + table_name + " ("  + ",".join([format_column_name(cell, output_format) for cell in row]) + ") FROM stdin WITH (delimiter '" + DELIMITER +"', format CSV, null 'null');\n")
                continue
            line = DELIMITER.join([format(cell) for cell in row])
            if row[0] == latestApplicationName:
                print("\tERROR: Duplicate application name is not supported: " + row[0])
                ERRORS = True
            else:
                f.write(line)
                f.write("\n")      
            latestApplicationName = row[0]    
        f.write("\\.\n")
        f.close()

def transform(mode, extract_directory, transform_directory, table_name, nb_primary_columns):
    global WARNINGS
    ofile = os.path.join(transform_directory, table_name + ".sql")
    ifile = os.path.join(extract_directory, table_name + ".csv")

    if not os.path.isfile(ifile):
        return

    print ("Transform", table_name)        
    f = open(ofile, "w", encoding="utf-8")

    if mode in ["refresh", "hd-update"]:
        f.write("TRUNCATE TABLE :schema." + table_name + " CASCADE;\n")

    with open(ifile, newline="", encoding="UTF-8") as csv_file:

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

def transform_ed_tables(mode, extract_directory, transform_directory, table_name, nb_primary_columns, column_name):
    global WARNINGS
    if mode != 'ed-update': 
        transform (mode,  extract_directory, transform_directory, table_name, 0)
        return

    ofile = os.path.join(transform_directory, table_name + ".sql")
    ifile = os.path.join(extract_directory, table_name + ".csv")

    if not os.path.isfile(ifile):
        return
    
    print ("Transform", table_name)
    
    f = open(ofile, "w", encoding="utf-8")

    with open(ifile, newline="", encoding="UTF-8") as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=DELIMITER)
        skip = True
        latestKeys = None
        column_value = None
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
            new_column_value = row[column_position] if column_name == 'application_name' else row[column_position].split(':')[0]
            #print(column_name, new_column_value, table_name, column_value)
            if column_value != new_column_value:
                if column_value != None:
                    f.write("\\.\n")                   
                if column_name != 'application_name':
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

def usage():
    print("This command should be called from run.bat (Windows) or run.sh (Linux/Docker) or datamart.bat (Windows) or datamart.sh (Linux/Docker)")
    print("Usage is")
    print()
    print("Single Data Source")
    print("transform install ROOT DOMAIN")
    print("    Add COPY statement to CSV content")
    print("transform refresh ROOT DOMAIN")
    print("    Add TRUNCATE AND COPY Statements to CSV content")
    print()
    print("Multiple Data Source")
    print("transform install HD_ROOT AAD")
    print("    Add COPY statement to CSV content")
    print("transform ed-install ED_ROOT DOMAIN")
    print("    Add COPY statement to CSV content")
    print("transform refresh^|hd-update HD_ROOT AAD")
    print("    Add TRUNCATE AND COPY Statements to CSV content")
    print("transform ed-update ED_ROOT ED_DOMAIN")
    print("    Add DELETE and COPY statement to CSV content")
    sys.exit(1)
    

if __name__ == "__main__":
    parser = argparse.ArgumentParser(formatter_class=argparse.RawDescriptionHelpFormatter, description="Transform Extract CSV iles into SQL statements for PostgreSQL")
    parser.add_argument("-i", "--extract", dest="extract_directory", action="store", help="set input extract directory")
    parser.add_argument("-o", "--transform", dest="transform_directory", action="store", help="set output transform directory")
    parser.add_argument("-m", "--mode", dest="mode", action="store", help="set generation mode: refresh, install, ed-update, hd-update")
    parser.add_argument("-d", "--domain", dest="domain", action="store", help="the domain to transform")
    args = parser.parse_args()
    
    if not args.mode in ['install', 'refresh', 'ed-install', 'hd-update', 'ed-update']:
        usage()

    if args.mode in ['refresh', 'install', 'hd-update']:
        transform_dim_applications(args.mode, args.extract_directory, args.transform_directory, "datamart")
        # Add DATAPOND table
        if datapond:
            transform_dim_applications(args.mode, args.extract_directory, args.transform_directory, "datapond")
            
        for entry in DATAMART:
            if entry["origin"] != 'hd':
                continue
            if entry["table"] == "DIM_APPLICATIONS":
                continue
            transform(args.mode, args.extract_directory, args.transform_directory, entry["table"], entry["nb_primary_columns"])

    if args.mode != 'hd-update':
        for entry in DATAMART:
            if entry["origin"] != 'ed':
                continue
            transform_ed_tables(args.mode, args.extract_directory, args.transform_directory, entry["table"], entry["nb_primary_columns"], entry["column_name"])

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
        print("== Transform Failed ==")
        exit(1)
        
    print("== Transform Done ==")