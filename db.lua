local sqlite3 = require( "sqlite3" )
local module = {}

local db
local function openDBAndInit()
    -- Open "data.db". If the file doesn't exist, it will be created
    local path = system.pathForFile( "data.db", system.DocumentsDirectory )
    db = sqlite3.open( path )   
    
    -- Handle the "applicationExit" event to close the database
    local function onSystemEvent( event )
        if ( event.type == "applicationExit" ) then             
            db:close()
        end
    end
    Runtime:addEventListener( "system", onSystemEvent )

    -- Set up the table if it doesn't exist
    local tablesetup = [[CREATE TABLE IF NOT EXISTS words (
        id INTEGER PRIMARY KEY, 
        word TEXT UNIQUE,
        translation TEXT,
        category TEXT,
        count INTEGER
    );]]
    local ret = db:exec( tablesetup )
    print(ret)

    local tablefill = [[INSERT INTO words VALUES (NULL, 'apple', 'りんご', 'fruit', 0); ]]
    local tablefill2 = [[INSERT INTO words VALUES (NULL, 'orange', 'みかん', 'fruit', 0); ]]
    local tablefill3 = [[INSERT INTO words VALUES (NULL, 'strawberry', 'いちご', 'fruit', 0); ]]
    local tablefill3 = [[INSERT INTO words VALUES (NULL, 'grape', 'ぶどう', 'fruit', 0); ]]
    local tablefill3 = [[INSERT INTO words VALUES (NULL, 'watermelon', 'すいか', 'fruit', 0); ]]
    db:exec( tablefill )
    db:exec( tablefill2 )
    db:exec( tablefill3 )

    print( "SQLite version " .. sqlite3.version() )
end

openDBAndInit()

function module.getWordsForCategory(category)
    arr = {}
    index = 1
    for row in db:nrows("SELECT * FROM words WHERE category='"..category.."'") do
        arr[index] = {
            id = row.id,
            word = row.word,
            translation = row.translation,
            count = row.count
        }
        index = index + 1
    end
    return arr
end

return module
