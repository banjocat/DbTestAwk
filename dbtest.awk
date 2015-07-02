
BEGIN {
    db = ""
    dbexec = ""
    passed = 0
    failed = 0
}

# Grammar
/^;.+/ {next}
/^DB:/ {db = $2; next}
/^DB_EXEC:/ {dbexec = $2; next}
/^TABLE_EXIST/ {table_exist($2); next}
/^COLUMN_EXIST/ {column_exist($2, $3); next}
/^RECORD_EXIST/ {record_exist($2, $3); next}
/[^ ].+/ {syntax_error("Unknown syntax: " $0) }

END {
    print("Total tests:", passed + failed)
    print("Tests passed:", passed)
    print("Tests failed:", failed)
}



function table_exist(table)
{
    db_check()
    error_check(table, "requires table name")
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
}


function exec_sql(statement)
{
    cmd = dbexec " " db " \"" statement "\" 2>/dev/null"
    return system(cmd)
}


function syntax_error(msg)
{
    print("Error line", NR, ": ", msg);
    exit(-1)
}
# Checks if starting variables are set yet
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
        passed += 1
        return
    }
    print("Failed line:", NR, "->", $0)
    failure += 1
}

