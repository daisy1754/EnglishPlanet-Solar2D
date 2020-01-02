local composer = require( "composer" )
local scene = composer.newScene()

local centerX = display.contentCenterX
local centerY = display.contentCenterY

local unitX = display.contentWidth / 1000.0
local unitY = display.contentHeight / 1000.0

function scene:create( event ) 
	local sceneGroup = self.view

    local gameMusic = audio.loadStream( "music/main.mp3" )
	audio.play( gameMusic, { loops = -1 } )

	bgGroup = display.newGroup()
	sceneGroup:insert( bgGroup )

	mainGroup = display.newGroup()
	sceneGroup:insert( mainGroup )

	uiGroup = display.newGroup() 
	sceneGroup:insert( uiGroup ) 

	local function initBackground()
        local background = display.newImageRect( bgGroup, "images/bg_blue.png", display.contentWidth, display.contentHeight )
        background.x = centerX
        background.y = centerY
	end

	initBackground()
end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end

function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

	end
end

function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
