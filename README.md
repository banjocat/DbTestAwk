# DbTestAwk
sqlite3 is required to be installed

## What problem does it solve?
I needed a way to test database migrations in sqlite3.

## How does it solve it?
It is a domain specific language created in AWK that allows testing
that migrations are done properly on a sqlite3 database.

## Why use AWK?
Because AWK is awesome. Even the name AWK is great. The language
was ahead of its time.
I also followed the amazing book "The AWK programming langauge"
which shows how to make domain specific languages in AWK.

## How does it work
To execute it
  
    awk -f dbtest.awk (testfile)
    
The language is defined below

    ; This is a comment
    ; This is the name of the database defined at top of file
    DB: sqlite3 
    ; The name of the command to execute the database. Normally this should just be sqlite3
    DB_EXEC sqlite3 
    
    ; Now for the tests
    ; Confirms that the table bob exists
    TABLE_EXIST bob
    ; Confirms that the table bob has column 'name'
    COLUMN_EXIST bob name 
    ; Confirms that the table bob has a record with name='bob'
    RECORD_EXIST bob name='bob'
  
Test reports look like below.

    Failed line: 12 -> TABLE_EXIST icecream
    Failed line: 18 -> COLUMN_EXIST people no
    Failed line: 20 -> COLUMN_EXIST icecream flavor
    Failed line: 27 -> RECORD_EXIST people name='Jack' AND wife='Not Cassie'

    **********************
    Total tests: 9
    Tests passed: 5
    Tests failed: 4


