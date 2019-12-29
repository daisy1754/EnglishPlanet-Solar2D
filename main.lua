-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- music
-- local gameMusic = audio.loadStream( "music/main.mp3" )
-- audio.play( gameMusic, { loops = -1 } )

local unitX = display.contentWidth / 1000.0;
local unitY = display.contentHeight / 1000.0;
local planet

local function initBackground() 
    local background = display.newImageRect( "images/bg_blue.png", display.contentWidth, display.contentHeight )
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    display.setDefault("textureWrapX", "repeat")
    display.setDefault("textureWrapY", "repeat")
    local starts = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
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

local playerSheet = graphics.newImageSheet( "images/player_sheets.png", {
    width = unitX * 150,
    height = unitX * 150 * 250 / 181,
    sheetContentWidth = unitX * 150 * 2,
    sheetContentHeight = unitX * 150 * 250 / 181, 
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
player.y = planet.y - planet.contentWidth / 2 - (unitX * 150 * 250 / 181 / 2)

balloon = display.newImageRect( "images/balloon.png", unitX * 450, unitX * 320 )
balloon.x = display.contentCenterX
balloon.y = planet.y - (planet.contentHeight + unitX * 320) / 2 - player.contentHeight
balloon.isVisible = false
local function toggleBalloon()
    balloon.isVisible = not balloon.isVisible
end
 
planet:addEventListener( "tap", toggleBalloon )