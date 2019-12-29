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

    local bgGroup = display.newGroup(sceneGroup)
    local function initBackground() 
        local background = display.newImageRect( bgGroup, "images/bg_blue.png", display.contentWidth, display.contentHeight )
        background.x = display.contentCenterX
        background.y = display.contentCenterY

        display.setDefault("textureWrapX", "repeat")
        display.setDefault("textureWrapY", "repeat")
        starWidth = display.contentWidth
        starHeight = display.contentHeight
        if starWidth / starHeight < 1424 / 1751 then
            starHeight = starWidth * 1751 / 1424
            print( starWidth)
            print( starHeight)
        else
            starWidth = starHeight * 1424 / 1751
        end
        local starts = display.newRect(bgGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
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

    local playerWidth = unitX * 150
    local playerHeight = playerWidth * 250 / 181
    local playerSheet = graphics.newImageSheet( "images/player_sheets.png", {
        width = playerWidth,
        height = playerHeight,
        sheetContentWidth = playerWidth * 2,
        sheetContentHeight = playerHeight, 
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
    player.y = planet.y - planet.contentWidth / 2 - (playerHeight / 2)

    local function placeAlien()
        local width = unitX * 150
        local height = width * 167 / 177
        local sheet = graphics.newImageSheet( "images/aliens/aliens01.png", {
            width = width,
            height = height,
            sheetContentWidth = width * 3,
            sheetContentHeight = height, 
            numFrames = 3,
        })
        local player = display.newSprite(sheet, {
            name = "walk",
            start = 2,
            count = 2,
    
            loopCount = 0,
            time = 1000
        })
        -- TODO: かぶらないようにする
        while player.rotation < 20 or player.rotation > 340 do
            player.rotation = math.random(360)
        end

        player:play()
        radius = planet.contentWidth / 2 + (height / 2)
        player.x = planet.x + math.sin(math.rad(player.rotation)) * radius
        player.y = planet.y - math.cos(math.rad(player.rotation)) * radius
        if player.rotation > 180 then
            player.xScale = -1
        end
    end
    placeAlien()
    placeAlien()
    placeAlien()
    placeAlien()

    local balloonGroup = display.newGroup(sceneGroup) 
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
