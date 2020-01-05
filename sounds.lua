local module = {}

function module.playMusic(name)
    local soundEnabled = system.getPreference( "app", "soundEnabled", "boolean" )
    if not soundEnabled then
        return nil
    end
    bgm = audio.loadStream( name )
    audio.play( bgm, { loops = -1 } )
    return bgm
end

function module.pause(music)
    if music ~= nil then
        audio.pause(music)
    end
end

function module.playEffect(name)
    local soundEnabled = system.getPreference( "app", "soundEnabled", "boolean" )
    if not soundEnabled then
        return nil
    end
    audio.play(name)
end

return module
