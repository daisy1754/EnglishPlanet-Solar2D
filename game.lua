local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()

local soundTable = { 
    correct = audio.loadSound( "soundeffects/correct_answer.wav" ),
    incorrect = audio.loadSound( "soundeffects/uhoh.wav" ),
}

function scene:create( event ) 
    local sceneGroup = self.view
    -- music
    local gameMusic = audio.loadStream( "music/main.mp3" )
    audio.play( gameMusic, { loops = -1 } )

    local unitX = display.contentWidth / 1000.0;
    local unitY = display.contentHeight / 1000.0;
    local planet
    local stars

    local state_init = 1
    local state_quiz_start = 2
    local state_quiz_accept_answer = 3
    local game_state = state_init

    local bgGroup = display.newGroup()
	local zoomableGroup = display.newGroup()
	sceneGroup:insert(bgGroup)
	sceneGroup:insert(zoomableGroup)
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
        stars = display.newRect(zoomableGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
        stars.fill = {type = "image", filename = "images/bg_stars.png" }
        local function animateBackground()
            transition.to( stars.fill, { time=20000, x=1, y=-0.3, delta=true, onComplete=animateBackground } )
        end
        animateBackground()

        local function shareScreenshot()
            local stage = display.currentStage

            display.save( stage, "image.png", system.DocumentsDirectory )

            timer.performWithDelay(100, function()
                local listener = {}
                function listener:popup( event )
                    print( "name: " .. event.name )
                    print( "type: " .. event.type )
                    print( "action: " .. tostring( event.action ) )
                    print( "limitReached: " .. tostring( event.limitReached ) )
                end
                native.showPopup( "social",
                {
                    listener = listener,
                    message= "hello",
                    url =
                    {
                        "http://www.coronalabs.com",
                    },
                    image =
                    {
                        { filename="image.png", baseDir=system.DocumentsDirectory },
                    },
                })
            end)
        end
        local function placeIcon(src, index, onTap)
            icon = display.newImageRect( bgGroup, src, unitX * 140, unitX * 140 )
            icon.x = display.contentWidth - unitX * 140 * index - unitX * 80
            if index == 3 then
                icon.x = icon.x - unitX * 15
            end
            icon.y = unitY * 70

            icon:addEventListener( "tap", onTap )
		end
		local function openAlbum() 
			composer.gotoScene( "album", { time=800, effect="crossFade" } )
		end
        placeIcon("images/icon_star.png", 3, openAlbum)
        placeIcon("images/icon_book.png", 2, openAlbum)
        placeIcon("images/icon_share.png", 1, shareScreenshot)
        placeIcon("images/icon_setting.png", 0, openAlbum)

        planet = display.newImageRect( zoomableGroup, "images/planet.png", unitX * 550, unitX * 550 )
        planet.x = display.contentCenterX
        planet.y = display.contentCenterY + unitY * 100
    end
    initBackground()

    local playerWidth = unitX * 150
    local playerHeight = playerWidth * 242 / 168
    local playerRadius = (planet.contentWidth + playerHeight) / 2 - unitX * 2
    local playerSheet = graphics.newImageSheet( "images/character.png", {
        width = playerWidth,
        height = playerHeight,
        sheetContentWidth = playerWidth * 9,
        sheetContentHeight = playerHeight, 
        numFrames = 9,
    })
    local player = display.newSprite(zoomableGroup, playerSheet, {
        {
            name = "standby",
            start = 1,
            count = 2,
            loopCount = 0,
            time = 1000
        },
        {
            name = "incorrect",
            start = 3,
            count = 2,
            loopCount = 1,
            time = 500
        },
        {
            name = "correct",
            start = 5,
            count = 5,
            loopCount = 1,
            time = 600
        },
    })

    player:play()
    player.x = planet.x
    player.y = planet.y - playerRadius

    local alien1
    local alienRadius
    local function initAlien(src)
        local width = unitX * 150
        local height = width * 226 / 177
        local sheet = graphics.newImageSheet( src, {
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
        alienRadius = planet.contentWidth / 2 + (height / 2) - unitX * 5
        alien.x = planet.x + math.sin(math.rad(alien.rotation)) * alienRadius
        alien.y = planet.y - math.cos(math.rad(alien.rotation)) * alienRadius
        if alien.rotation > 180 then
            alien.xScale = -1
        end
        alien1 = alien

        local function mayChangeMotion()
            if  game_state ~= state_init then
                return
            end

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
        local function mayMove()
            if alien.sequence == "walking" then
                local speed = alien.xScale > 0 and math.random() or -math.random();
                alien.rotation = (alien.rotation + speed) % 360
                alien.x = planet.x + math.sin(math.rad(alien.rotation)) * alienRadius
                alien.y = planet.y - math.cos(math.rad(alien.rotation)) * alienRadius
            end
        end
        timer.performWithDelay(2000, mayChangeMotion, -1)
        timer.performWithDelay(100, mayMove, -1)
    end
    initAlien("images/aliens/aliens01.png")
    initAlien("images/aliens/aliens02.png")
    initAlien("images/aliens/aliens03.png")
    initAlien("images/aliens/aliens04.png")
    initAlien("images/aliens/aliens05.png")
    initAlien("images/aliens/aliens06.png")
    initAlien("images/aliens/aliens07.png")

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
    local balloonText = display.newText({
        parent = zoomableGroup,
        text = "ねぇ   apple   って\nどういう いみ だっけ?",     
        x = planet.x,
        y = balloon.y,
        width = balloon.contentWidth - unitX * 120,
        height = balloon.contentHeight - unitY * 60,
        font = "fonts/PixelMplus12-Regular.ttf",   
        fontSize = 16,
        align = "center"
    })
    balloonText:setFillColor( 0, 0, 0 )
    balloonText.isVisible = false

    local function toggleBalloon()
        balloon.isVisible = not balloon.isVisible
        balloonText.isVisible = false
        transition.fadeOut(stars)
        local zoom = 2
        if game_state == state_init then
            game_state = state_quiz_start
            balloon:play()
            local function showBalloonText()
                balloonText.isVisible = true
            end
            local function scheduleShowBalloonText()
                timer.performWithDelay(100, showBalloonText, 1)
            end
            transition.to( zoomableGroup, { 
                time=500,
                transition=easing.inOutQuad, 
                xScale=zoom,
                yScale=zoom,
                x= -display.contentWidth * 0.5,
                onComplete=scheduleShowBalloonText
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
        elseif game_state == state_quiz_start then
            game_state = state_quiz_accept_answer
            local buttons = {}
            local function placeButton(index, label, isCorrect)
                local function onPress()
                    local function onAnswer()
                        transition.fadeOut( buttons[index], { time=1000 })

                        local function standby()
                            player:setSequence("standby")
                            player:play()
                        end

						if isCorrect then
							audio.play( soundTable["correct"] )
                            player:setSequence("correct")
                            player:play()
                            timer.performWithDelay(700, standby, 1)
                        else 
							audio.play( soundTable["incorrect"] )
                            player:setSequence("incorrect")
                            player:play()
                            timer.performWithDelay(1500, standby, 1)
                        end
                    end
                    for i=0,2 do
                        if i ~= index then
                            transition.fadeOut( buttons[i], { time=400, onComplete=onAnswer } )
                        end
                    end
                end
                local button = widget.newButton(
                    {
                        label = label,
                        shape = "roundedRect",
                        width = display.contentWidth * 0.8,
                        height = display.contentHeight * 0.1,
                        cornerRadius = unitX * 40,
                        labelColor = { default={ 0, 0, 0 }, over={ 0,0,0 } },
                        font = "fonts/PixelMplus12-Regular.ttf",
                        fontSize = unitX * 80,
                        fillColor = { default={1,1,1,1}, over={1,1,1,1} },
                        onPress = onPress
                    }
                )
                button.x = display.contentCenterX
                button.y = display.contentHeight * 0.14 * index + display.contentHeight * 0.2
                buttons[index] = button
            end
            placeButton(0, "みかん", false)
            placeButton(1, "りんご", true)
            placeButton(2, "いちご", false)
        else
            game_state = state_init
            transition.to( zoomableGroup, { time=300, transition=easing.inOutQuad, xScale=1, yScale=1, x=0} )

            local radius = (planet.contentWidth + playerHeight) / 2
            player.x = planet.x
            player.y = planet.y - playerRadius
            player.rotation = 0
        end
    end
    
    planet:addEventListener( "tap", toggleBalloon )
    balloon:addEventListener( "tap", toggleBalloon )
    balloonText:addEventListener( "tap", toggleBalloon )
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
