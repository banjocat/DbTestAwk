# DbTestAwk

## What the heck does this do?
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
    
The language is defind below

    ; This is a comment
    DB: sqlite3 ; This is the name of the database defined at top of file
    DB_EXEC sqlite3 ; The name of the command to execute the database. Normally this should just be sqlite3
    
    ; Now for the tests
    TABLE_EXIST bob ; Confirms that the table bob exists
    COLUMN_EXIST bob name ; Confirms that the table bob has column 'name'
    RECORD_EXIST bob name='bob' ; Confirms that the table bob has a record with name='bob'
  



