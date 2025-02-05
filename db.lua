local sqlite3 = require( "sqlite3" )
local seed = require( "db_seed" )
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

    -- debug
    db:exec( 'DROP TABLE IF EXISTS words;')

    -- Set up the table if it doesn't exist
    local tablesetup = [[CREATE TABLE IF NOT EXISTS words (
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        word TEXT UNIQUE,
        translation TEXT,
        category TEXT,
        seen INTEGER DEFAULT 0,
        known INTEGER DEFAULT 0
    );]]
    local ret = db:exec( tablesetup )
    print(ret)

    db:exec( seed.seedQuery )

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
            seen = row.seen ~= 0,
            known = row.known ~= 0
        }
        index = index + 1
    end
    return arr
end

function module.markWordAsSeen(word)
    return db:exec(string.format("UPDATE words SET seen = 1 WHERE word='%s'", word))
end

function module.markWordAsKnown(word)
    return db:exec(string.format("UPDATE words SET known = 1 WHERE word='%s'", word))
end

return module
