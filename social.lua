local module = {}

function module.shareScreenshot(stage)
    display.save( stage, "image.png", system.DocumentsDirectory )

    timer.performWithDelay(100, function()
        local listener = {}
        function listener:popup( event )
            print( "name: " .. event.name )
            print( "type: " .. event.type )
            print( "action: " .. tostring( event.action ) )
            print( "limitReached: " .. tostring( event.limitReached ) )
        end
        native.showPopup( "social",
        {
            listener = listener,
            message= "hello",
            url =
            {
                "http://www.coronalabs.com",
            },
            image =
            {
                { filename="image.png", baseDir=system.DocumentsDirectory },
            },
        })
    end)
end

return module