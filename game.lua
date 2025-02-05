local composer = require( "composer" )
local db = require( "db" )
local flurry = require( "flurry" )
local menus = require( "menus" )
local quiz = require( "quiz" )
local starInfo = require( "stars" )
local sounds = require( "sounds" )
local widget = require( "widget" )
local scene = composer.newScene()

local centerX = display.contentCenterX
local centerY = display.contentCenterY

local unitX = display.contentWidth / 1000.0
local unitY = display.contentHeight / 1000.0

local soundTable = { 
    correct = audio.loadSound( "soundeffects/correct_answer.wav" ),
    incorrect = audio.loadSound( "soundeffects/uhoh.wav" ),
}

local thankYou = {
	"どうもありがとう",
	"どうもありがと〜ん",
	"ありがとね",
	"ありがとね〜ん",
	"ありがとう",
	"ありがと!"
}

local zoomableGroup
local planet
local bgm

function initPlanet()
    if planet ~= nil then
        planet:removeSelf()
    end

	local starIndex = system.getPreference( "app", "selectedStarIndex", "number" ) or 1
	planet = display.newImageRect( zoomableGroup, "images/stars/" .. starInfo[starIndex].image .. ".png", unitX * 550, unitX * 550 )
	planet.x = centerX
    planet.y = centerY + unitY * 100
end

function scene:create( event ) 
    local sceneGroup = self.view

	local stars
	local placeAlien
	local words
	local aliens = {}
	local selectedAlien

    local state_init = 1
    local state_quiz_start = 2
    local state_quiz_accept_answer = 3
    local state_quiz_answer_correct = 4
    local state_quiz_answer_correct_wait_transition = 5
    local state_quiz_answer_incorrect = 6
    local game_state = state_init

    local bgGroup = display.newGroup()
	zoomableGroup = display.newGroup()
	sceneGroup:insert(bgGroup)
	sceneGroup:insert(zoomableGroup)
    local function initBackground() 
        local background = display.newImageRect( bgGroup, "images/bg_blue.png", display.contentWidth, display.contentHeight )
        background.x = centerX
        background.y = centerY

        display.setDefault("textureWrapX", "repeat")
        display.setDefault("textureWrapY", "repeat")
        starWidth = display.contentWidth
        starHeight = display.contentHeight
        if starWidth / starHeight > 1424 / 1751 then
            starHeight = starWidth * 1751 / 1424
        else
            starWidth = starHeight * 1424 / 1751
        end
        stars = display.newRect(
			bgGroup, 
			centerX, centerY, 
			starWidth, starHeight)
        stars.fill = {type = "image", filename = "images/bg_stars.png" }
        local function animateBackground()
            transition.to( stars.fill, { time=20000, x=1, y=-0.3, delta=true, onComplete=animateBackground } )
        end
        animateBackground()

        local menuGroup = menus.renderMenus()
        sceneGroup:insert(menuGroup)

		initPlanet()
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

	local function resetPlayer()
		player.x = planet.x
		player.y = planet.y - playerRadius
		player.rotation = 0
	end
    resetPlayer()

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
		
		placeAlien = function(a)
			-- TODO: かぶらないようにする
			while a.rotation < 20 or a.rotation > 340 do
				a.rotation = math.random(360)
			end
			
			alienRadius = planet.contentWidth / 2 + (height / 2) - unitX * 5
			a.x = planet.x + math.sin(math.rad(a.rotation)) * alienRadius
			a.y = planet.y - math.cos(math.rad(alien.rotation)) * alienRadius
		end

		placeAlien(alien)
        alien:play()
        if alien.rotation > 180 then
            alien.xScale = -1
        end
        aliens[#aliens + 1] = alien

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
	for i=1, 7 do
		initAlien("images/aliens/aliens0" .. i .. ".png")
	end

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
    balloon.x = centerX
    balloon.y = planet.y - (planet.contentHeight + balloonHeight) / 2 - player.contentHeight
    balloon.isVisible = false
    local balloonText = display.newText({
        parent = zoomableGroup,
        text = "",     
        x = planet.x,
        y = balloon.y,
        width = balloon.contentWidth - unitX * 120,
        height = balloon.contentHeight - unitY * 60,
        font = "fonts/PixelMplus12-Bold.ttf",   
        fontSize = 16,
        align = "center"
    })
    balloonText:setFillColor( 0, 0, 0 )
	balloonText.isVisible = false
	
	local function showBalloon()
		balloon.isVisible = true
		balloonText.isVisible = true
	end
	
	function scheduleShowBalloon()
		timer.performWithDelay(100, showBalloon, 1)
	end

	local function hideBalloon()
		balloon.isVisible = false
		balloonText.isVisible = false
	end

	local function zoom(ratio, time, onComplete)
		transition.to( zoomableGroup, { 
			time=time,
			transition=easing.inOutQuad, 
			xScale=ratio,
			yScale=ratio,
			x= -(display.contentWidth * (ratio - 1)) / 2,
			onComplete=onComplete
		} )
	end

    local hasFailed = false
    local advanceGame = function()
        balloon.isVisible = false
        balloonText.isVisible = false
        transition.fadeOut(stars)
        if game_state == state_init then
            game_state = state_quiz_start
			balloon:play()
            local starIndex = system.getPreference( "app", "selectedStarIndex", "number" ) or 1
            words = quiz.startQuiz(starInfo[starIndex].db)
            hasFailed = false
			balloonText.text = 'ねぇ   '..words.answer.word..'   って\nどういう いみ だっけ?'
			zoom(2, 500, scheduleShowBalloon)

            player.x = planet.x + math.sin(math.rad(350)) * playerRadius
            player.y = planet.y - math.cos(math.rad(350)) * playerRadius
            player.rotation = 350

			selectedAlien = aliens[math.random(#aliens)]
            selectedAlien.x = planet.x + math.sin(math.rad(10)) * alienRadius
            selectedAlien.y = planet.y - math.cos(math.rad(10)) * alienRadius
            selectedAlien.rotation = 10
            selectedAlien.xScale = 1
            selectedAlien:setSequence("still")
            selectedAlien:pause()
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
						
						local function playEffect(name, delayToStandby)
							sounds.playEffect( soundTable[name] )
                            player:setSequence(name)
                            player:play()
							timer.performWithDelay(delayToStandby, standby, 1)
						end

						zoom(2.2, 500)
						if isCorrect then
							game_state = state_quiz_answer_correct
							playEffect("correct", 700)
							local function showCorrectMsg()
								balloonText.text = "そうだ!\n" .. words.answer.translation .. "だった!"
								showBalloon()
							end
                            timer.performWithDelay(1000, showCorrectMsg, 1)
                            if not hasFailed then
                                db.markWordAsKnown(words.answer.word)
                            end
                        else 
							game_state = state_quiz_answer_incorrect
							playEffect("incorrect", 1500)
							local function showIncorrectMsg()
								balloonText.text = "うーん\nちがうような"
								showBalloon()
							end
                            timer.performWithDelay(1000, showIncorrectMsg, 1)
                            hasFailed = true
                        end
                    end
                    for i=1,3 do
                        if i ~= index then
                            transition.fadeOut( buttons[i], { time=400, onComplete=onAnswer } )
                        end
                    end
                    return true
                end
                local button = widget.newButton(
                    {
                        label = label,
                        shape = "roundedRect",
                        width = display.contentWidth * 0.8,
                        height = display.contentHeight * 0.1,
                        cornerRadius = unitX * 40,
                        labelColor = { default={ 0, 0, 0 }, over={ 0,0,0 } },
                        font = "fonts/PixelMplus12-Bold.ttf",
                        fontSize = unitX * 80,
                        fillColor = { default={1,1,1,0.8}, over={1,1,1,1} },
                        onPress = onPress
                    }
                )
                button.x = centerX
                button.y = display.contentHeight * 0.14 * (index - 1) + display.contentHeight * 0.2
                buttons[index] = button
			end
			arr = {}
			arr[1] = words.answer.translation
			arr[2] = words.other1.translation
			arr[3] = words.other2.translation
			shuffled={}
			for i, v in ipairs(arr) do
				local pos = math.random(1, #shuffled+1)
				table.insert(shuffled, pos, v)
			end
			for i=1, 3 do
				placeButton(i, shuffled[i], shuffled[i] == words.answer.translation)
			end
		elseif game_state == state_quiz_accept_answer then
			-- wait for answer, ignore tap
        elseif game_state == state_quiz_answer_correct then
            game_state = state_quiz_answer_correct_wait_transition
			balloonText.text = thankYou[math.random(#thankYou)]
			showBalloon()
			local function endQuiz()
				hideBalloon()
                function resetThings()
                    game_state = state_init
                    resetPlayer()
                    placeAlien(selectedAlien)
                end
				zoom(1, 300, resetThings)
			end
			timer.performWithDelay(2000, endQuiz, 1)
        elseif game_state == state_quiz_answer_correct_wait_transition then
            -- ignore tap
		elseif game_state == state_quiz_answer_incorrect then
			game_state = state_quiz_start
			balloonText.text = 'ねぇ   '..words.answer.word..'   って\nどういう いみ だっけ?'
			zoom(2, 300)
			showBalloon()
        else
			-- should never happen
			print('invalid state')
        end
    end

    bgGroup:addEventListener( "tap", advanceGame )
end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
        initPlanet()

        local starIndex = system.getPreference( "app", "selectedStarIndex", "number" ) or 1
        bgm = sounds.playMusic( "music/" .. starInfo[starIndex].music .. ".mp3" )
	elseif ( phase == "did" ) then
        flurry.recordCurrentScreen()
	end
end

function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
        sounds.pause(bgm)

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
