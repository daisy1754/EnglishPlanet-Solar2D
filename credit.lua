local composer = require( "composer" )
local sounds = require( "sounds" )
local scene = composer.newScene()

local centerX = display.contentCenterX
local centerY = display.contentCenterY

local unitX = display.contentWidth / 1000.0
local unitY = display.contentHeight / 1000.0

function scene:create( event ) 
	local sceneGroup = self.view

	sounds.playMusic( "music/main.mp3" )

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
		
		local friendWidth = unitX * 2685
		local friendHeight = unitX * 293
		local friends = {}
		local activeIndex = 1
		local friend1 = display.newImageRect( bgGroup, "images/friends.png", friendWidth, friendHeight )
		local friend2 = display.newImageRect( bgGroup, "images/friends.png", friendWidth, friendHeight )
        friend1.x = centerX
		friend1.y = display.contentHeight - friend1.contentHeight
        friend2.x = centerX + friendWidth
		friend2.y = display.contentHeight - friend1.contentHeight
		friends[1] = friend1
		friends[2] = friend2
		local speed = 0.1

		local function resetFriendPositionAndAnimate()
			friends[1].x = friends[2].x + friendWidth
			transition.moveTo( friends[1], {
				x = - friendWidth / 2,
				time = (friends[1].x + friendWidth / 2) / speed,
				onComplete = resetFriendPositionAndAnimate
			})
			local tmp = friends[1]
			friends[1] = friends[2]
			friends[2] = tmp
		end
		transition.moveTo( friend1, {
			x = - friendWidth / 2,
			time = (friend1.x + friendWidth / 2) / speed,
			onComplete = resetFriendPositionAndAnimate
		})
		transition.moveTo( friend2, {
			x = - friendWidth / 2,
			time = (friend2.x + friendWidth / 2) / speed,
			onComplete = resetFriendPositionAndAnimate
		})


		local credit = display.newImageRect( bgGroup, "images/credit.png", unitX * 700, unitX * 700 * 1295 / 791 )
		credit.x = display.contentCenterX
		credit.y = display.contentCenterY - friendHeight / 2
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
