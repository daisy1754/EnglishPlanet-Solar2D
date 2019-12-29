-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------


local gameMusic = audio.loadStream( "music/main.mp3" )
audio.play( gameMusic, { loops = -1 } )

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

local planet = display.newImageRect( "images/planet.png", display.contentWidth / 2, display.contentWidth / 2 )
planet.x = display.contentCenterX
planet.y = display.contentCenterY
