local composer = require( "composer" )
local scene = composer.newScene()

local centerX = display.contentCenterX
local centerY = display.contentCenterY

local unitX = display.contentWidth / 1000.0
local unitY = display.contentHeight / 1000.0

local starInfo = {
    { name = "うみの いきもの", image = "umi"},
    { name = "てんき", image = "tenki"},
    { name = "かぞく", image = "kazoku"},
    { name = "こうどう", image = "koudou"},
    { name = "りくの いきもの", image = "riku"},
    { name = "のりもの", image = "norimono"},
    { name = "もの", image = "mono"},
    { name = "じかん", image = "jikan"},
    { name = "たべもの", image = "tabemono"},
}
local angles = {
    0,
    65,
    95,
    135,
    165,
    -165,
    -135,
    -95,
    -65
}

local swipeStar
local stars = {}
local currentOffset = 1

local function touchHandler(event)
    local swipeLength = math.abs(event.x - event.xStart) 
    print(event.phase, swipeLength)

    local t = event.target
    local phase = event.phase

    if (phase == "began") then

    elseif (phase == "moved") then

    elseif (phase == "ended" or phase == "cancelled") then

        if (event.xStart > event.x and swipeLength > 50) then 
            swipeStar(1)
        elseif (event.xStart < event.x and swipeLength > 50) then 
            swipeStar(-1)
        end
    end
end

function scene:create( event ) 
	local sceneGroup = self.view

	bgGroup = display.newGroup()
	sceneGroup:insert( bgGroup )

	mainGroup = display.newGroup()
	sceneGroup:insert( mainGroup )

	uiGroup = display.newGroup()    -- Display group for UI objects like the score
	sceneGroup:insert( uiGroup )    -- Insert into the scene's view group

	local function initBackground()
        local background = display.newImageRect( bgGroup, "images/bg_blue.png", display.contentWidth, display.contentHeight )
        background.x = centerX
        background.y = centerY

        starWidth = display.contentWidth
        starHeight = display.contentHeight
        if starWidth / starHeight > 1424 / 1751 then
            starHeight = starWidth * 1751 / 1424
        else
            starWidth = starHeight * 1424 / 1751
        end
        stars = display.newImageRect(bgGroup, "images/bg_stars.png", starWidth, starHeight)
        stars.x = centerX
        stars.y = centerY
    end

    local function getStarPosition(angle) 
        return {
            x = display.contentCenterX + unitX * 400 * math.cos(math.rad(angle)),
            y = display.contentCenterY - unitY * 100 + 0.7 * unitX * 400 * math.sin(math.rad(angle))
        }
    end

    local function getStarZoom(angle) 
        if angle == 90 then
            return 1.6
        elseif math.sin(math.rad(angle)) < 0 then    
            return 1 + math.sin(math.rad(angle)) * 5 / 10
        else
            return 1 + math.sin(math.rad(angle)) * 2 / 10
        end
    end

    local function initStars()
        stars = {}
        for i, info in ipairs(starInfo) do
            local star = display.newImageRect(mainGroup, "images/stars/" .. info.image .. ".png", unitX * 300, unitX * 300)
            local angle = angles[i] + 90
            local position = getStarPosition(angle)
            star.x = position.x
            star.y = position.y
            stars[#stars + 1] = star
        end
        local function adjustZoom() 
            for i, star in ipairs(stars) do
                local angle = angles[i] + 90
                star:scale(getStarZoom(angle), getStarZoom(angle))
            end
        end
        local function adjustZIndex()
            for i=1,4 do
                bgGroup:insert(stars[5-i])
            end
            for i=1,4 do
                bgGroup:insert(stars[5+i])
            end
        end
        adjustZoom()
        adjustZIndex()

        local starNameFrame = display.newRoundedRect( mainGroup, centerX, 
            stars[1].y + stars[1].contentHeight / 2 + unitX * 140,  unitX * 600, unitX * 120, unitX * 30 )
        starNameFrame:setFillColor( 1, 1, 1, 0.8 )
		
		local titleText = display.newText({
			parent = mainGroup,
			text = starInfo[1].name .. " プラネット",     
			x = starNameFrame.x,
			y = starNameFrame.y,
			width = starNameFrame.contentWidth,
			font = "fonts/PixelMplus12-Regular.ttf",   
			fontSize = 20,
			align = "center"
		})
        titleText:setFillColor( 0 )
        
        swipeStar = function(offset)
            currentOffset = (currentOffset - offset - 1) % #angles + 1
            local transitionDuration = 200
            for i, star in ipairs(stars) do
                local nextAngle = angles[(i + offset - 1) % #angles + 1] + 90
                local nextPosition = getStarPosition(nextAngle)
                local nextZoom = getStarZoom(nextAngle)
                transition.to( star, { 
                    time=transitionDuration,
                    transition=easing.inOutQuad, 
                    xScale=nextZoom,
                    yScale=nextZoom,
                    x=nextPosition.x,
                    y=nextPosition.y,
                } )
            end
            local function onDone()
                local tmp = {}
                for i, star in ipairs(stars) do
                    tmp[(i + offset - 1) % #stars + 1] = star
                end
                stars = tmp
                adjustZIndex()
                titleText.text = starInfo[currentOffset].name .. " プラネット"
            end
            timer.performWithDelay(transitionDuration, onDone, 1)
        end
    end

    local function initPlayer()
        local playerWidth = unitX * 300
        local playerHeight = playerWidth * 504 / 382
        local playerSheet = graphics.newImageSheet( "images/moving.png", {
            width = playerWidth,
            height = playerHeight,
            sheetContentWidth = playerWidth * 8,
            sheetContentHeight = playerHeight, 
            numFrames = 8,
        })
        local player = display.newSprite(mainGroup, playerSheet, {
            {
                name = "moving",
                start = 1,
                count = 8,
                loopCount = 0,
                time = 2000
            },
        })
        player.x = unitX * 50 + playerWidth / 2
        player.y = display.contentHeight - unitY * 50 - playerHeight / 2
        player:play()
    end

    initBackground()
    initStars()
    initPlayer()
    Runtime:addEventListener("touch", touchHandler)
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
    Runtime:removeEventListener("touch", touchHandler)

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
