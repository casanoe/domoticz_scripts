--[[
name : Bose.lua
version: 1.0

auteur : casanoe
creation : 21/07/2019
mise à  jour : 21/07/2019

Switch on/off a Bose speaker.
Detect if a Bose speaker is active.

Tested on Bose Soundtouch 30.

TODO: change station, change volume

--]]
return {
	on = {
		timer = {
			'every 5 minutes'
		},
		httpResponses = {
			'timerbosestatus', 'devicebosestatus'
		},
		devices = {
			'Présence Bose'
		}
	},

	execute = function(domoticz, item)
		
		-- IP of Bose HP
		local ip = 'bose'
		-- Name of the device (switch) to update
		local swbose = 'Présence Bose'
		
		if (item.isTimer or item.isDevice) then
		    cb = 'timerbosestatus'
		    if (item.isDevice) then
		        cb = 'devicebosestatus'       
		    end
		    domoticz.openURL({
				url = 'http://'..ip..':8090/now_playing',
				method = 'GET',
				callback = cb
		    })
        end
		
		if (item.isHTTPResponse and item.ok) then
            b = (string.find(item.data, "STANDBY") ~= nil)
            s = domoticz.devices('Présence Bose').state
            if (item.trigger == 'devicebosestatus') then
                if ((s == 'On' and b) or (s =='Off' and not b)) then
    			    domoticz.openURL({
        				url = 'http://'..ip..':8090/key',
        				method = 'POST',
        				callback = 'nocallbackbose',
        				headers = 'application/xml',
        				postData = ' <key state="press" sender="Gabbo">POWER</key> '
        	        })
	            end
	        end
	        
	        if (item.trigger == 'timerbosestatus') then
        	    if ((s == 'On' and b) or (s =='Off' and not b)) then
            	    if (b) then 
                        domoticz.devices(swbose).switchOff()
                    else
                        domoticz.devices(swbose).switchOn()
                    end
                end
            end
        
	   end
	   
	end
}
