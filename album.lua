local composer = require( "composer" )
local scene = composer.newScene()

local centerX = display.contentCenterX
local centerY = display.contentCenterY

local unitX = display.contentWidth / 1000.0
local unitY = display.contentHeight / 1000.0

function scene:create( event ) 
	local sceneGroup = self.view

    local gameMusic = audio.loadStream( "music/album.mp3" )
	audio.play( gameMusic, { loops = -1 } )
	
	bgGroup = display.newGroup()
	sceneGroup:insert( bgGroup )

	mainGroup = display.newGroup()
	sceneGroup:insert( mainGroup )

	uiGroup = display.newGroup()
	sceneGroup:insert( uiGroup )
	
	local function initBackground()
		display.setDefault("background", 183/255, 229/255, 168/255)

		local angle = -10
		local height = unitX * 70
		local width = unitX * 622
		local xMargin = unitX * 80
		local yMargin = unitY * 30
		local x = 0
		local y = 0
		local i = 1
		local items = {}
		while y < display.contentHeight + height + yMargin do
			local rows = {}
			while x < display.contentWidth + width do
				local item = display.newImageRect(bgGroup, "images/bg_album_text.png", width, height)
				item.x = (x + width / 2) * math.cos(math.rad(angle))
				item.y = y + height / 2 + (x + width / 2) * math.sin(math.rad(angle))
				item.rotation = angle
				rows[#rows + 1] = item
				local function onExitScreen()
					local currentItem = rows[1]
					local size = #rows
					for i = 1,size-1 do
						rows[i] = rows[i + 1]
					end
					rows[size] = currentItem
					lastItem = rows[size - 1]
					currentItem.x = lastItem.x + (width + xMargin) * math.cos(math.rad(angle))
					currentItem.y = lastItem.y + (width + xMargin) * math.sin(math.rad(angle))
					local newX = -width * math.cos(math.rad(angle)) / 2
					transition.moveTo( currentItem, {
						x = newX,
						y = currentItem.y - (-newX + currentItem.x) * math.sin(math.rad(angle)),
						time = (width / 2 + currentItem.x) * 10000 / display.contentWidth,
						onComplete = onExitScreen
					})
				end
				-- animate until element is moved out of screen
				local newX = -width * math.cos(math.rad(angle)) / 2
				transition.moveTo( item, {
					x = newX,
					y = item.y - (-newX + item.x) * math.sin(math.rad(angle)),
					time = (width / 2 + item.x) * 10000 / display.contentWidth,
					onComplete = onExitScreen
				})
				x = x + width + xMargin
			end
			items[#items + 1] = rows
			x = (#items % 4) * width / 4 - width / 2
			y = y + height + yMargin
		end

	end

	local function initAlbumFrame()
        local frame = display.newRect( bgGroup, centerX, centerY + unitY * 75,  unitX * 900, unitY * 700 )
        frame.strokeWidth = 5
        frame:setFillColor( 1, 1, 1, 0.8 )
		frame:setStrokeColor( 1 )
		
		local titleText = display.newText({
			parent = bgGroup,
			text = "ずかん",     
			x = centerX,
			y = centerY - unitY * 220,
			width = frame.contentWidth,
			font = "fonts/PixelMplus12-Regular.ttf",   
			fontSize = 24,
			align = "center"
		})
		titleText:setFillColor( 0 )
		local subtitle = display.newText({
			parent = bgGroup,
			text = "おぼえた たんごを ふくしゅう しよう！",     
			x = centerX,
			y = centerY - unitY * 220 + 30,
			width = frame.contentWidth,
			font = "fonts/PixelMplus12-Regular.ttf",   
			fontSize = 16,
			align = "center"
		})
		subtitle:setFillColor( 0 )
    end

	local function initAlbumItems()
		local numColumns = 3
		local function initAlbumItem(index)
			local frame = display.newRoundedRect(
				uiGroup, 
				unitX * 270 * (index % numColumns) + unitX * 220,
				unitY * 200 * math.ceil(index / numColumns) + unitY * 230,
				unitX * 220, 
				unitY * 150,
			    unitX * 15 )
			frame:setStrokeColor( 0 )
			frame.strokeWidth = 3
			frame:setFillColor( 1 )

			local img = display.newImageRect(uiGroup, "images/hakase1.png", unitX * 200, unitX * 200)
			img.x = frame.x
			img.y = frame.y

			local name = display.newText({
				parent = uiGroup,
				text = "もの はかせ",     
				x = frame.x,
				y = frame.y + frame.contentHeight / 2 - 16,
				width = frame.contentWidth,
				font = "fonts/PixelMplus12-Regular.ttf",   
				fontSize = 16,
				align = "center"
			})
			name:setFillColor( 0 )
		end

		for i=1,9 do
			initAlbumItem(i)
		end
	end

	initBackground()
	initAlbumFrame()
	initAlbumItems()
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
