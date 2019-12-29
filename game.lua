local composer = require( "composer" )
local scene = composer.newScene()

function scene:create( event ) 
    local sceneGroup = self.view
    -- music
    -- local gameMusic = audio.loadStream( "music/main.mp3" )
    -- audio.play( gameMusic, { loops = -1 } )

    local unitX = display.contentWidth / 1000.0;
    local unitY = display.contentHeight / 1000.0;
    local planet

    local function initBackground() 
        local background = display.newImageRect( "images/bg_blue.png", display.contentWidth, display.contentHeight )
        background.x = display.contentCenterX
        background.y = display.contentCenterY

        display.setDefault("textureWrapX", "repeat")
        display.setDefault("textureWrapY", "repeat")
        local starts = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
        starts.fill = {type = "image", filename = "images/bg_stars.png" }
        local function animateBackground()
            transition.to( starts.fill, { time=30000, x=1, y=-0.6, delta=true, onComplete=animateBackground } )
        end
        animateBackground()

        planet = display.newImageRect( "images/planet.png", unitX * 500, unitX * 500 )
        planet.x = display.contentCenterX
        planet.y = display.contentCenterY + unitY * 100
    end
    initBackground()

    local playerSheet = graphics.newImageSheet( "images/player_sheets.png", {
        width = unitX * 150,
        height = unitX * 150 * 250 / 181,
        sheetContentWidth = unitX * 150 * 2,
        sheetContentHeight = unitX * 150 * 250 / 181, 
        numFrames = 2,
    })
    local player = display.newSprite(playerSheet, {
        name = "standby",
        start = 1,
        count = 2,

        loopCount = 0,
        time = 1000
    })
    player:play()
    player.x = planet.x
    player.y = planet.y - planet.contentWidth / 2 - (unitX * 150 * 250 / 181 / 2)

    local balloonGroup = display.newGroup() 
    balloonGroup.isVisible = false
    balloon = display.newImageRect( balloonGroup, "images/balloon.png", unitX * 450, unitX * 320 )
    balloon.x = display.contentCenterX
    balloon.y = planet.y - (planet.contentHeight + unitX * 320) / 2 - player.contentHeight
    local balloonText = display.newText( balloonGroup, "ねえ apple ってどういういみだっけ?", planet.x, balloon.y, balloon.contentWidth - unitX * 30, balloon.contentHeight - unitY * 10, "fonts/PixelMplus12-Regular.ttf", 30 )
    balloonText:setFillColor( 0, 0, 0 )
    local function toggleBalloon()
        balloonGroup.isVisible = not balloonGroup.isVisible
    end
    
    planet:addEventListener( "tap", toggleBalloon )
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
