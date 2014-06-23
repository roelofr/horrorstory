--[[
	Settings
]]--

function GM:SetSetting( setting, value )
	if not GAMEMODE.Settings then gamemode.Call("LoadSettings") end
	
	GAMEMODE.Settings[setting] = value
	
	GAMEMODE:SaveSettings()
end

function GM:GetSetting( setting )
	if not GAMEMODE.Settings then gamemode.Call("LoadSettings") end
	
	if GAMEMODE.Settings[setting] != nil then
		return GAMEMODE.Settings[setting]
	else
		return nil
	end
end

function GM:LoadSettings() 
	local settingsFile = "horrorstory/settings_server.txt"
	
	local defaultSettings = {
		["enableFlashlights"] = false,
		["enableNoclipForAdmins"] = false,
		["ragdollCollision"] = false,
		["defaultHUDTexture"] = "angry",
		["overrideHideHUD"] = false,
		["overrideHUDTexture"] = false
	}
	
	if file.Exists( settingsFile, "DATA" ) then
		local savedSettings = file.Read( settingsFile, "DATA" )
		savedSettings = util.JSONToTable( savedSettings )
		if type( savedSettings ) == "table" then
			table.Merge( defaultSettings, savedSettings )
		end
	end 
	
	if not GAMEMODE.Settings then GAMEMODE.Settings = {} end
	
	// Enforced
	defaultSettings["ragdollCollision"] = false
	
	defaultSettings['maplist'], _ = file.Find( "maps/*.bsp", "GAME" )
	
	table.Merge( GAMEMODE.Settings, defaultSettings )
	
end

function GM:SaveSettings()

	local settingsFile = "horrorstory/settings_server.txt"
	
	if not GAMEMODE.Settings then gamemode.Call("LoadSettings") end
	
	if not file.IsDir( "horrorstory", "DATA" ) then file.CreateDir( "horrorstory" ) end
	
	local clone = table.Copy( GAMEMODE.Settings )
	clone['map'] = nil
	clone['maplist'] = nil
	
	file.Write( settingsFile, util.TableToJSON( clone ) )
end

function GM:SendSettings( ply )

	if not GAMEMODE.Settings then gamemode.Call("LoadSettings") end
	
	if type( ply ) != "string" and not IsValid( ply ) then return end
	
	net.Start( "HorrorStory_ServerSettings" )
		net.WriteString("fetch")
		net.WriteTable(GAMEMODE.Settings)
		
	if ply == "*" then
		net.Broadcast()
	else
		net.Send( ply )
	end
end

net.Receive( "HorrorStory_ServerSettings", function( length, pl )
	
	if not GAMEMODE.Settings then gamemode.Call("LoadSettings") end
	
	local action = net.ReadString()
	if action == "fetch" then
		
		gamemode.Call( "SendSettings", pl )
		
	elseif action == "put" then
		if not pl:IsAdmin() then
			net.Start( "HorrorStory_ServerSettings" )
				net.WriteString("put")
				net.WriteString("You are not authorised to do that!")
			net.Send( pl )
		else
			local data = net.ReadTable()
			
			for key, value in pairs( data ) do
				if GAMEMODE.Settings[ key ] != nil and GAMEMODE.Settings[ key ] != value then
					gamemode.Call( "SetSetting", key, value )
				end
			end
			
			gamemode.Call( "SendSettings", "*" )
		end
	end

end )