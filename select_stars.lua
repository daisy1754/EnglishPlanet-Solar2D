local composer = require( "composer" )
local scene = composer.newScene()

local centerX = display.contentCenterX
local centerY = display.contentCenterY

local unitX = display.contentWidth / 1000.0
local unitY = display.contentHeight / 1000.0

local starNames = {
    "umi",
    "tenki",
    "kazoku",
    "koudou",
    "riku",
    "norimono",
    "mono",
    "jikan",
    "tabemono"
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

    local function initStars()
        local stars = {}
        for i, starName in ipairs(starNames) do
            local star = display.newImageRect(mainGroup, "images/stars/" .. starName .. ".png", unitX * 300, unitX * 300)
            local angle = angles[i] + 90
            star.x = display.contentCenterX + unitX * 400 * math.cos(math.rad(angle))
            star.y = display.contentCenterY - unitY * 100 + 0.7 * unitX * 400 * math.sin(math.rad(angle))
            local zoom 
            if i == 1 then
                zoom = 1.6
            elseif math.sin(math.rad(angle)) < 0 then    
                zoom = 1 + math.sin(math.rad(angle)) * 5 / 10
            else
                zoom = 1 + math.sin(math.rad(angle)) * 2 / 10
            end
            star:scale(zoom, zoom)
            stars[#stars + 1] = star
            print(string.format("%s %d %f", starName, angle, math.sin(math.rad(angle))))
        end
        for i=1,4 do
            bgGroup:insert(stars[5-i])
        end

        local starNameFrame = display.newRect( mainGroup, centerX, 
            stars[1].y + stars[1].contentHeight / 2 + unitX * 120,  unitX * 600, unitX * 120 )
        starNameFrame:setFillColor( 1, 1, 1, 0.8 )
		
		local titleText = display.newText({
			parent = mainGroup,
			text = "たべもの プラネット",     
			x = starNameFrame.x,
			y = starNameFrame.y,
			width = starNameFrame.contentWidth,
			font = "fonts/PixelMplus12-Regular.ttf",   
			fontSize = 24,
			align = "center"
		})
		titleText:setFillColor( 0 )
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
