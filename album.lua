local composer = require( "composer" )
local db = require("db")
local widget = require( "widget" )
local scene = composer.newScene()

local centerX = display.contentCenterX
local centerY = display.contentCenterY

local unitX = display.contentWidth / 1000.0
local unitY = display.contentHeight / 1000.0

function scene:create( event ) 
	local sceneGroup = self.view

	local frame
	local imgs = {}
	local names = {}

    local gameMusic = audio.loadStream( "music/album.mp3" )
	audio.play( gameMusic, { loops = -1 } )
	
	bgGroup = display.newGroup()
	sceneGroup:insert( bgGroup )

	albumGroup = display.newGroup()
	sceneGroup:insert( albumGroup )

	hakaseGroup = display.newGroup()
	sceneGroup:insert( hakaseGroup )

	detailsGroup = display.newGroup()
	sceneGroup:insert( detailsGroup )
	
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
        frame = display.newRect( bgGroup, centerX, centerY + unitY * 75,  unitX * 900, unitY * 700 )
        frame.strokeWidth = 5
        frame:setFillColor( 1, 1, 1, 0.8 )
		frame:setStrokeColor( 1 )
		
		local titleText = display.newText({
			parent = albumGroup,
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
			parent = albumGroup,
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

	local function showItemDetails(index)
		-- hide others
		for i=1,9 do
			if i ~= index then
				imgs[i].isVisible = false
				names[i].isVisible = false
			end
		end

		local animationDuration = 500
		transition.to( frame, {
			time = animationDuration,
			y = centerY,
			height = unitY * 900
		})
		transition.to( imgs[index], {
			time = animationDuration,
			y = centerY - unitY * 300,
			x = centerX,
			height = unitX * 300,
			width = unitX * 300
		})
		local function showName()
			names[index].isVisible = false
			local name = display.newText({
				parent = animationDuration,
				text = "もの はかせ",     
				x = centerX,
				y = centerY - unitY * 200,
				width = display.contentWidth,
				fontSize = 24,
				font = "fonts/PixelMplus12-Regular.ttf", 
				align = "center"
			})
			name:setFillColor( 0 )
			names[index] = name
		end
		transition.to( names[index], {
			time = animationDuration,
			x = centerX,
			y = centerY - unitY * 200,
			width = display.contentWidth,
			size = 24,
			onComplete = showName
		})
		
		local function showWords()
			local category = 'fruit'
			local words = db.getWordsForCategory(category)
			local function onRowRender( event )
				local row = event.row
			
			   -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
			   local rowHeight = row.contentHeight
			   local rowWidth = row.contentWidth
			
			   local wordLabel = '?????'
			   if words[row.index].seen then
					wordLabel = words[row.index].word
			   end
			   local word = display.newText({
				   parent = row,
				   text = wordLabel,     
				   fontSize = 24,
				   font = "fonts/PixelMplus12-Regular.ttf", 
				   width = rowWidth / 2
			   })
			   word:setFillColor( 0 )
			   word.anchorX = 0
			   word.x = unitX * 100
			   word.y = rowHeight / 2

			   local translationLabel = '?????'
			   if words[row.index].known then
				translationLabel = words[row.index].translation
			   end
			   local translation = display.newText({
					parent = row,
					text = translationLabel,     
					fontSize = 24,
					font = "fonts/PixelMplus12-Regular.ttf", 
					width = rowWidth / 2
				})
				translation:setFillColor( 0 )
				translation.anchorX = 0
				translation.x = unitX * 50 + rowWidth / 2
				translation.y = rowHeight / 2
		   end
   
		   local tableView = widget.newTableView(
			   {
				   x = centerX,
				   y = centerY + unitY * 150,
				   height = unitY * 600,
				   width = unitX * 900,
				   backgroundColor = { 0, 0, 0, 0 },
				   onRowRender = onRowRender,
			   }
		   )
   
		   for i = 1, #words do
			   -- Insert a row into the tableView
			   tableView:insertRow{
				   rowHeight = unitX * 100,
				   rowColor = { default={ 0, 0, 0, 0 }, over={ 0, 0, 0, 0 } },				
				   lineColor = { 0, 0, 0, 0 }
			   }
		   end
		end

		timer.performWithDelay(animationDuration, showWords, 1)
	end

	local function initAlbumItems()
		local numColumns = 3
		local function initAlbumItem(index)
			local frame = display.newRoundedRect(
				albumGroup, 
				unitX * 270 * (index % numColumns) + unitX * 220,
				unitY * 200 * math.ceil(index / numColumns) + unitY * 230,
				unitX * 220, 
				unitY * 150,
			    unitX * 15 )
			frame:setStrokeColor( 0 )
			frame.strokeWidth = 3
			frame:setFillColor( 1 )
			local function onTapItem()
				albumGroup.isVisible = false
				showItemDetails(index)
			end
			frame:addEventListener( "tap", onTapItem )

			local img = display.newImageRect(hakaseGroup, "images/hakase1.png", unitX * 200, unitX * 200)
			img.x = frame.x
			img.y = frame.y
			imgs[index] = img

			local name = display.newText({
				parent = hakaseGroup,
				text = "もの はかせ",     
				x = frame.x,
				y = frame.y + frame.contentHeight / 2 - 16,
				width = frame.contentWidth,
				font = "fonts/PixelMplus12-Regular.ttf",   
				fontSize = 16,
				align = "center"
			})
			name:setFillColor( 0 )
			names[index] = name
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
