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
    local stars
    -- "initial", "quiz_start", "quiz_answer", "quiz_correct", "quiz_wrong"
    local state = "initial"

    local bgGroup = display.newGroup()
    local zoomableGroup = display.newGroup()
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
        else
            starWidth = starHeight * 1424 / 1751
        end
        stars = display.newRect(bgGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
        stars.fill = {type = "image", filename = "images/bg_stars.png" }
        local function animateBackground()
            transition.to( stars.fill, { time=30000, x=1, y=-0.6, delta=true, onComplete=animateBackground } )
        end
        animateBackground()

        local function placeIcon(src, index)
            icon = display.newImageRect( bgGroup, src, unitX * 90, unitX * 90 )
            icon.x = display.contentWidth - unitX * 120 * index - unitX * 80
            icon.y = unitY * 70
        end
        placeIcon("images/icon_stars.png", 3)
        placeIcon("images/icon_book.png", 2)
        placeIcon("images/icon_screenshot.png", 1)
        placeIcon("images/icon_settings.png", 0)

        planet = display.newImageRect( zoomableGroup, "images/planet.png", unitX * 500, unitX * 500 )
        planet.x = display.contentCenterX
        planet.y = display.contentCenterY + unitY * 100
    end
    initBackground()

    local playerWidth = unitX * 150
    local playerHeight = playerWidth * 250 / 181
    local playerRadius = (planet.contentWidth + playerHeight) / 2
    local playerSheet = graphics.newImageSheet( "images/player_sheets.png", {
        width = playerWidth,
        height = playerHeight,
        sheetContentWidth = playerWidth * 2,
        sheetContentHeight = playerHeight, 
        numFrames = 2,
    })
    local player = display.newSprite(zoomableGroup, playerSheet, {
        name = "standby",
        start = 1,
        count = 2,

        loopCount = 0,
        time = 1000
    })
    player:play()
    player.x = planet.x
    player.y = planet.y - playerRadius

    local alien1
    local alienRadius
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
        local alien = display.newSprite(zoomableGroup, sheet, {
            {
                name = "walking",
                start = 2,
                count = 2,
        
                loopCount = 0,
                time = 1000
            },
            {
                name="still",
                start=1,
                count=1
            }
        })
        -- TODO: かぶらないようにする
        while alien.rotation < 20 or alien.rotation > 340 do
            alien.rotation = math.random(360)
        end

        alien:play()
        radius = planet.contentWidth / 2 + (height / 2)
        alien.x = planet.x + math.sin(math.rad(alien.rotation)) * radius
        alien.y = planet.y - math.cos(math.rad(alien.rotation)) * radius
        if alien.rotation > 180 then
            alien.xScale = -1
        end
        alienRadius = radius
        alien1 = alien

        local function mayChangeMotion()
            if math.random() < 0.2 then
                if alien.sequence == "walking" then
                    alien:setSequence("still")
                end
            else
                if alien.sequence ~= "walking" then
                    alien:setSequence("walking")
                    alien:play()
                end
            end

            if math.random() < 0.5 then
                alien.xScale = -1
            else
                alien.xScale = 1
            end
        end
        timer.performWithDelay(2000, mayChangeMotion, -1)
    end
    placeAlien()
    placeAlien()
    placeAlien()
    placeAlien()

    local balloonWidth = unitX * 510
    local balloonHeight = playerWidth * 926 / 648
    local balloonSheet = graphics.newImageSheet( "images/balloon_sheet.png", {
        width = balloonWidth,
        height = balloonHeight,
        sheetContentWidth = balloonWidth * 6,
        sheetContentHeight = balloonHeight, 
        numFrames = 6,
    })
    local balloon = display.newSprite(zoomableGroup, balloonSheet, {
        name = "zoomin",
        start = 1,
        count = 6,
        loopCount = 1,
        time = 700
    })
    balloon.x = display.contentCenterX
    balloon.y = planet.y - (planet.contentHeight + balloonHeight) / 2 - player.contentHeight
    balloon.isVisible = false
    local balloonText = display.newText( zoomableGroup, "ねえ apple って どういう いみ だっけ?", 
        planet.x, balloon.y, 
        balloon.contentWidth - unitX * 120, balloon.contentHeight - unitY * 60, "fonts/PixelMplus12-Regular.ttf", 16 )
    balloonText:setFillColor( 0, 0, 0 )
    balloonText.isVisible = false
    local function toggleBalloon()
        balloon.isVisible = not balloon.isVisible
        balloonText.isVisible = not balloonText.isVisible
        stars.isVisible = not balloon.isVisible
        local zoom = 2
        if balloon.isVisible then
            balloon:play()
            transition.to( zoomableGroup, { 
                time=500,
                transition=easing.inOutQuad, 
                xScale=zoom,
                yScale=zoom,
                -- ここのXの値よくわかってない
                x= -zoomableGroup.contentWidth * 0.75 
            } )

            player.x = planet.x + math.sin(math.rad(350)) * playerRadius
            player.y = planet.y - math.cos(math.rad(350)) * playerRadius
            player.rotation = 350

            alien1.x = planet.x + math.sin(math.rad(10)) * alienRadius
            alien1.y = planet.y - math.cos(math.rad(10)) * alienRadius
            alien1.rotation = 10
            alien1.xScale = -1
            alien1:setSequence("still")
            alien1:pause()
        else
            transition.to( zoomableGroup, { time=300, transition=easing.inOutQuad, xScale=1, yScale=1, x=0} )

            local radius = (planet.contentWidth + playerHeight) / 2
            player.x = planet.x
            player.y = planet.y - playerRadius
            player.rotation = 0
        end
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
