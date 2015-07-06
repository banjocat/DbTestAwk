
BEGIN {
    db = ""
    dbexec = ""
    pass = 0
    fail = 0
    print("TEST: ", ARGV[1])
}

# Grammar
/^;.+/ {next}
/^DB:/ {db = $2; next}
/^DB_EXEC:/ {dbexec = $2; next}
/^TABLE_EXIST/ {table_exist($2); next}
/^COLUMN_EXIST/ {column_exist($2, $3); next}
/^RECORD_EXIST/ {
    record_exist($2, substr($0, index($0, $3)))
    next
}
/[^ ].+/ {syntax_error("Unknown syntax: " $0) }

END {
    print("\n")
    print("**********************")
    print("Total tests:", pass + fail)
    print("Tests passed:", pass)
    print("Tests failed:", fail)
}

function table_exist(table)
{
    db_check()
    error_check(table, "requires table name")
    statement = "SELECT * from " table ";"
    pass_or_fail(exec_sql(statement))
}

function column_exist(table, column)
{
    db_check()
    error_check(table, "requires table name")
    error_check(column, "requires column name")
    statement = "SELECT " column " from " table ";"
    pass_or_fail(exec_sql(statement))
}

function record_exist(table, where)
{
    db_check()
    error_check(table, "requires table name")
    error_check(where, "requires where field")
    statement = "SELECT count(*) from " \
        table " WHERE " where ";"
    # Check for sytanx error
    cmd = dbexec " " db " \"" statement "\" \
        2>/dev/null "
    # Check for count
    ret = system(cmd " 1>/dev/null")
    cmd | getline output
    if (ret != 0 || output == "0" || output == "") {
        print_failure()
        return
    }
    pass += 1
}


function exec_sql(statement)
{
    cmd = dbexec " " db " \"" statement "\" \
        1>/dev/null 2>/dev/null"
    return system(cmd)
}


function syntax_error(msg)
{
    print("Error line", NR, ": ", msg);
    exit(-1)
}

function db_check()
{
    if (db == "") {
        print("DB: not defined")
        exit(-1)
    }
    if (dbexec == "") {
        print("DB_TYPE: not defined")
        exit(-1)
    }
}

function error_check(field, error)
{
    if (field == "") {
        syntax_error(error)
    }
}

function pass_or_fail(ret)
{
    if (ret == 0) {
        pass += 1
        return
    }
    print_failure()
}

function print_failure()
{
    fail += 1
    print("Failed line:", NR, "->", $0)
}


