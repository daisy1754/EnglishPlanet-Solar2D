-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )

math.randomseed( os.time() )
composer.gotoScene( "game" )

local function onKeyEvent( event )
	-- If the "back" key was pressed and we have previous screen, then prevent it from backing out of the app.
	-- We do this by returning true, telling the operating system that we are overriding the key.
    if (event.keyName == "back" and event.phase == "up") then
        local currScene = composer.getSceneName( "current" )
        local prevScene = composer.getSceneName( "previous" )
        if prevScene and currScene ~= "game" then
            composer.gotoScene( prevScene )
            return true
        end
	end

    -- Return false to indicate that this app is *not* overriding the received key.
	-- This lets the operating system execute its default handling of this key.
	return false
end

Runtime:addEventListener( "key", onKeyEvent );
