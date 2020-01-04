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

    local insert = [[INSERT INTO words ('word', 'translation', 'category') VALUES('apple ', 'りんご', 'fruit'),
        ('orange', 'みかん', 'fruit'),
        ('strawberry', 'いちご', 'fruit'),
        ('grape', 'ぶどう', 'fruit'),
        ('watermelon', 'すいか', 'fruit'),
        ('tea', 'おちゃ', 'fruit'),
        ('coffee', 'コーヒー', 'fruit'),
        ('milk', 'ぎゅうにゅう', 'fruit'),
        ('rice', 'ごはん', 'fruit'),
        ('soup', 'スープ', 'fruit'),
        ('egg', 'たまご', 'fruit'),
        ('pizza', 'ピザ', 'fruit'),
        ('chocolate', 'チョコレート', 'fruit'),
        ('pumpkin', 'かぼちゃ', 'fruit'),
        ('potato', 'じゃがいも', 'fruit'),
        ('onion', 'たまねぎ', 'fruit'),
        ('carrot', 'にんじん', 'fruit'),
        ('chiken', 'とりにく', 'fruit'),
        ('bread', 'パン', 'fruit'),
        ('water', 'みず', 'fruit');
    ]]
    db:exec( insert )

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
