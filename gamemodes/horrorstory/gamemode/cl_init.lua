--[[---------------------------------------------------------
	{TMG} Horror Story - Client init
-----------------------------------------------------------]]

include( 'shared.lua' )
include( 'cl_settings.lua' )
include( 'sh_messages.lua' )
include( 'sh_openplugins.lua' )
include( 'sh_vgui.lua' )
include( 'skin/horror-story.lua' )

--
-- Make BaseClass available
--
DEFINE_BASECLASS( "gamemode_base" )

--[[---------------------------------------------------------
   Called after a game loaded or reloaded
-----------------------------------------------------------]]
function GM:HorrorStoryReady()
	if _G.hs_vgui != nil then
		if _G.hs_vgui.healthBar != nil and IsValid( _G.hs_vgui.healthBar ) then
			_G.hs_vgui.healthBar:Remove()
		end
		if _G.hs_vgui.notifications != nil and IsValid( _G.hs_vgui.notifications ) then
			_G.hs_vgui.notifications:Remove()
		end
	end

	GAMEMODE.gameDone = false
		
	net.Receive( "GameCompleted", function( length )
		local oldGameDone = tobool( GAMEMODE.gameDone )
		GAMEMODE.gameDone = tobool( net.ReadBit() )
		if GAMEMODE.gameDone != oldGameDone then
			if GAMEMODE.gameDone then
				GAMEMODE.notifications:AddNotification( {
					["text"] = "The map has been finished. Ask the host to change level",
					["color"] = "green",
					["time"] = 30
				}) -- Add a notification
			end
		end
	end)
	net.Receive( "HorrorStoryNotify", function( length )
		local readTable = net.ReadTable()
		GAMEMODE.notifications:AddNotification( readTable )
	end )
	
	GAMEMODE.healthBar = vgui.Create( "horrorstory_hud" )
	GAMEMODE.notifications = vgui.Create( "horrorstory_notifications" )
	
	if _G.hs_vgui == nil then _G.hs_vgui = {} end
	_G.hs_vgui.healthBar = GAMEMODE.healthBar
	_G.hs_vgui.notifications = GAMEMODE.notifications
	
	openPlugins:FlushHooks()
		
	--[[
		Add OpenPlugins from gamemode
	]]--
	print("[HorrorStory] Adding gamemode plugins" )
	openPlugins:AddDirectory( "horrorstory/gamemode/plugins", true, true )

	--[[
		Add OpenPlugins from user
	]]--
	if file.Exists( "plugins/horrorstory", "LUA" ) and file.IsDir( "plugins/horrorstory", "LUA" ) then
		print("[HorrorStory] Adding user plugins" )
		openPlugins:AddDirectory( "plugins/horrorstory", true, true )
	end
	
	net.Receive( "HorrorStoryHelp", function( u )
		gamemode.Call( "ShowHelp" )
	end )
	
	GAMEMODE.SettingsPanel = nil
end

--[[---------------------------------------------------------
   Called after the game has finished loading
-----------------------------------------------------------]]
function GM:Initialize()

	gamemode.Call( "HorrorStoryReady" )

	BaseClass.Initialize( self )
	
end

--[[---------------------------------------------------------
   Called after the game has reloaded
-----------------------------------------------------------]]
function GM:OnReloaded()

	gamemode.Call( "HorrorStoryReady" )

	BaseClass.OnReloaded( self )
	
end

--[[---------------------------------------------------------
   Decides if stuff should or should not be drawn
-----------------------------------------------------------]]
function GM:HUDShouldDraw( name )
	for k, v in pairs({"CHudHealth", "CHudBattery"}) do
		if name == v then
			return false
		end
	end
	return true
end

--[[---------------------------------------------------------
   Force a darker VGUI theme
-----------------------------------------------------------]]
function GM:ForceDermaSkin()
	return "HorrorStoryV2"
end

--[[---------------------------------------------------------
   Need some help here!
-----------------------------------------------------------]]
function GM:ShowHelp()
	GAMEMODE.SettingsPanel = vgui.Create( "horrorstory_settings" )
end