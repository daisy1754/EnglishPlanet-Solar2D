local composer = require( "composer" )
local flurryAnalytics = require( "plugin.flurry.analytics" )

local module = {}
local isInitialized = false
local queue = {}
local function init()
    local function flurryListener( event )
        if ( event.phase == "init" ) then
            isInitialized = false
            print( "init", event.provider )
            for i, item in ipairs(queue) do
                flurryAnalytics.logEvent( item.event, item.metadata )
            end
            queue = {}
        end
    end
     
    flurryAnalytics.init( flurryListener, { 
        apiKey="YG872DTWNPFTPV4F943K",
        crashReportingEnabled=true,
        logLevel="debug"
    })
end

init()

function logEvent(event, metadata)
    if isInitialized then
        flurryAnalytics.logEvent( event, metadata )
    else
        queue[#queue + 1] = {
            event = event,
            metadata = metadata
        }
    end
end

function module.recordCurrentScreen()
    logEvent( "Screen View", { screenName=composer.getSceneName( "current" ) } )
end

return module
