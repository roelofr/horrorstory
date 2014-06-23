--[[
	Settings
]]--

if not CLIENT then return end

--[[
	Client settings
]]--
function GM:SetClientSetting( setting, value )
	if not GAMEMODE.ClientSettings then gamemode.Call("LoadClientSettings") end
	
	GAMEMODE.ClientSettings[setting] = value
	
	GAMEMODE:SaveClientSettings()
end

function GM:GetClientSetting( setting )
	if not GAMEMODE.ClientSettings then gamemode.Call("LoadClientSettings") end
	
	if GAMEMODE.ClientSettings[setting] != nil then
		return GAMEMODE.ClientSettings[setting]
	else
		return nil
	end
end

function GM:LoadClientSettings() 
	local settingsFile = "horrorstory/settings_client.txt"
	
	local defaultSettings = {
		["HealthBarVisible"] = true,
		["HealthBarIcon"] = "firstaid_4",
		["HealthBarOpac"] = 200
	}
	
	if file.Exists( settingsFile, "DATA" ) then
		local savedSettings = file.Read( settingsFile, "DATA" )
		savedSettings = util.JSONToTable( savedSettings )
		if type( savedSettings ) == "table" then
			table.Merge( defaultSettings, savedSettings )
		end
	end 
	
	if not GAMEMODE.ClientSettings then GAMEMODE.ClientSettings = {} end
	
	table.Merge( GAMEMODE.ClientSettings, defaultSettings )
	
end

function GM:SaveClientSettings()

	local settingsFile = "horrorstory/settings_client.txt"
	
	if not GAMEMODE.ClientSettings then gamemode.Call("LoadClientSettings") end
	
	if not file.IsDir( "horrorstory", "DATA" ) then file.CreateDir( "horrorstory" ) end
	
	local clone = table.Copy( GAMEMODE.ClientSettings )
	clone['map'] = nil
	clone['maplist'] = nil
	
	file.Write( settingsFile, util.TableToJSON( clone ) )
end

--[[
	Server settings
]]--
function GM:LoadServerSettings()
	net.Start( "HorrorStory_ServerSettings" )
		net.WriteString("fetch")
	net.SendToServer()
end
function GM:SaveServerSettings()
	net.Start( "HorrorStory_ServerSettings" )
		net.WriteString("put")
		net.WriteTable( GAMEMODE.ServerSettings )
	net.SendToServer()
end
function GM:SetServerSetting( setting, value )
	if not GAMEMODE.ServerSettings then
		gamemode.Call("LoadServerSettings")
		return nil
	end
	
	GAMEMODE.ServerSettings[setting] = value
end

function GM:GetServerSetting( setting )
	if not GAMEMODE.ServerSettings then
		gamemode.Call("LoadServerSettings")
		return nil
	end
	
	if GAMEMODE.ServerSettings[setting] != nil then
		return GAMEMODE.ServerSettings[setting]
	else
		return nil
	end
end

net.Receive( "HorrorStory_ServerSettings", function( length )
	local action = net.ReadString()
	if action == "fetch" then
		local data = net.ReadTable()
		
		if not GAMEMODE.ServerSettings then GAMEMODE.ServerSettings = {} end
		
		table.Merge( GAMEMODE.ServerSettings, data )
	elseif action == "put" then
		local message = net.ReadString()
		if message != "x" then
			Derma_Message( message, "Message from server", "Okay" )
		end
	end

end )