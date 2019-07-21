--[[
name : mymodules.lua
version: 1.0

auteur : casanoe
creation : 21/07/2019
mise à  jour : 21/07/2019

Some usefull functions

--]]

-- Change with your domo url
domoip = "http://localhost:8084"

SwitchURL1 = domoip..'/json.htm?type=command&param=switchlight&idx='
SwitchURL2 = domoip..'/json.htm?type=command&param=switchscene&idx='

function script_path()
   local str = debug.getinfo(2, "S").source:sub(2)
   return str:match("(.*/)")
end

function pdebug(str)
	print("####DEBUG#### "..str)
end

function OsExec(commande)
  local cmd=commande..' > /tmp/josdOsExecute.log 2>&1'
  local reponse=os.execute(cmd)
  local file=assert(io.open("/tmp/josdOsExecute.log", "r"))
  local stdout=file:read("*all")
  assert(file:close())
  return (reponse==0 or reponse==true), stdout
end

function SwitchOn(device)
   SwitchDevice(device, "On")
end

function SwitchOnFor(device, secs)
   SwitchDevice(device, "On")
   commandArray[device] = "Off AFTER "..secs
end

function SwitchOff(device)
   SwitchDevice(device, "Off")
end

-- Toggle a device
function switch(device)
   SwitchDevice(device, "Toggle")
end

-- Switch a device
function SwitchDevice(device, cmd)
   os.execute('/usr/bin/curl -m 5 "'..SwitchURL1..otherdevices_idx[device]..'&switchcmd='..cmd..'" &')
end

-- Switch a device
function SwitchGroup(device, cmd)
   os.execute('/usr/bin/curl -m 5 "'..SwitchURL2..therdevices_scenesgroups_idx[device]..'&switchcmd='..cmd..'" &')
end

-- switch On a device and set level if dimmmable
function switchOnLevel(device, level)
   if level ~= nil then
      SwitchDevice(device, 'Set%20Level&level='..level..'" &')
   else   
      SwitchDevice(device, "On")
   end   
end

-- switch On a group or scene
function groupOn(device)
   SwitchGroup(device, "On")
end

-- switch Off a group
function groupOff(device)
   SwitchGroup(device, "Off")
end