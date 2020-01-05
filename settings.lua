local composer = require( "composer" )
local widget = require( "widget" )
local sounds = require( "sounds" )
local scene = composer.newScene()

local centerX = display.contentCenterX
local centerY = display.contentCenterY

local unitX = display.contentWidth / 1000.0
local unitY = display.contentHeight / 1000.0

local soundEnabled = system.getPreference( "app", "soundEnabled", "boolean" )

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
	end
	
	local function openCredit() 
		composer.gotoScene( "credit" )
	end

	local buttons = {}
	local function toggleSound() 
		soundEnabled = not soundEnabled
		local updated = system.setPreferences( "app", { soundEnabled=soundEnabled })
		buttons[2]:setLabel("サウンド " .. (soundEnabled and "OFF" or "ON" ))
	end

	local function placeButton(label, onPress)
		local button = widget.newButton(
			{
				label = label,
				parent = uiGroup,
				shape = "roundedRect",
				width = display.contentWidth * 0.9,
				height = display.contentHeight * 0.1,
				cornerRadius = unitX * 40,
				labelColor = { default={ 1 }, over={ 1 } },
				font = "fonts/PixelMplus12-Regular.ttf",
				fillColor = { default={ 0, 0, 0, 0 }, over={ 0, 0, 0, 0 } },
				fontSize = unitX * 80,
				strokeColor = { default={ 1 }, over={ 1 } },
				strokeWidth = 4,
				onPress = onPress
			}
		)
		button.x = centerX
		button.y = display.contentHeight * 0.14 * #buttons + display.contentHeight * 0.2
		uiGroup:insert(button)
		buttons[#buttons + 1] = button
	end

	local function openGame() 
		composer.gotoScene( "game" )
	end

	initBackground()
	placeButton("クレジット", openCredit)
	placeButton("サウンド " .. (soundEnabled and "OFF" or "ON" ), toggleSound)
	placeButton("レビュー をかく", openGame)
	placeButton("もどる", openGame)
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
