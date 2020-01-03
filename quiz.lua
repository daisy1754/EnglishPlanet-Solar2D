local db = require( "db" )

local module = {}

function module.startQuiz(category)
    local t = db.getWordsForCategory(category)
    local answer = t[math.random(#t)]
    local other1, other2
    
    db.markWordAsSeen(answer.word)

    while true do
        other1 = t[math.random(#t)]
        if answer["translation"] ~= other1["translation"] then break end
    end

    while true do
        other2 = t[math.random(#t)]
        if answer["translation"] ~= other1["translation"] 
          and other1["translation"] ~= other2["translation"] 
          and answer["translation"] ~= other2["translation"] then 
            break 
        end
    end
    
    return {
        answer = answer,
        other1 = other1,
        other2 = other2
    }
end

return module