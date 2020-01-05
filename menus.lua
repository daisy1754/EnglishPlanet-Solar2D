local composer = require( "composer" )
local social = require( "social" )

local module = {}

local unitX = display.contentWidth / 1000.0
local unitY = display.contentHeight / 1000.0

function module.renderMenus()
    local menuGroup = display.newGroup()

    local function placeIcon(src, index, onTap)
        icon = display.newImageRect( menuGroup, src, unitX * 140, unitX * 140 )
        icon.x = display.contentWidth - unitX * 140 * index - unitX * 80
        if index == 3 then
            icon.x = icon.x - unitX * 15
        end
        icon.y = unitY * 70

        icon:addEventListener( "tap", onTap )
    end
    local function openAlbum() 
        composer.gotoScene( "album", { time=200, effect="crossFade" } )
    end
    local function openSelectStars() 
        composer.gotoScene( "select_stars", { time=200, effect="crossFade" } )
    end
    local function shareScreenshot()
        social.shareScreenshot(display.currentStage)
    end
    local function openSettings() 
        composer.gotoScene( "settings" )
    end
    placeIcon("images/icon_star.png", 3, openSelectStars)
    placeIcon("images/icon_book.png", 2, openAlbum)
    placeIcon("images/icon_share.png", 1, shareScreenshot)
    placeIcon("images/icon_setting.png", 0, openSettings)

    return menuGroup
end

return module
