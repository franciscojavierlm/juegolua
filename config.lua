application = {
	content = {
		width =  640,
		height = 1136, 
		scale = "letterBox",
		fps = 30,
                xAlign = "left",
                yAlign = "top",
                --antialias = true,
		imageSuffix = {
                    ["@2x"] = 2, 
                    --["@3x"] = 3,
                }
		--[[
        imageSuffix = {
		    ["@2x"] = 2,
		}
		--]]
	},

    --[[
    -- Push notifications

    notification =
    {
        iphone =
        {
            types =
            {
                "badge", "sound", "alert", "newsstand"
            }
        }
    }
    --]]    
}

