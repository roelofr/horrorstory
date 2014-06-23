--[[---------------------------------------------------------
	{TMG} Horror Story - Server init
-----------------------------------------------------------]]

-- These files get sent to the client

AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_settings.lua" )
AddCSLuaFile( "sh_messages.lua" )
AddCSLuaFile( "sh_openplugins.lua" )
AddCSLuaFile( "sh_vgui.lua" )
AddCSLuaFile( "skin/horror-story.lua" )

include( 'shared.lua' )
include( 'sv_admincommand.lua' )
include( 'sv_player.lua' )
include( 'sv_resource.lua' )
include( 'sv_settings.lua' )

--
-- Make BaseClass available
--
DEFINE_BASECLASS( "gamemode_base" )

--[[---------------------------------------------------------
   Called every game tick, don't overstress
-----------------------------------------------------------]]
function GM:Think()

	if not GAMEMODE.NextRagdollCheck then GAMEMODE.NextRagdollCheck = RealTime() - 5 end
	
	if GAMEMODE.NextRagdollCheck < RealTime() - 5 then
		GAMEMODE.NextRagdollCheck = RealTime()
		for _, ent in pairs( ents.FindByClass( "func_ragdoll" ) ) do
			if ent:GetCollisionGroup() != COLLISION_GROUP_DEBRIS and !ent:IsPlayer() and !ent:IsNPC() then
				ent.oldCollisionGroup = ent:GetCollisionGroup()
				ent:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
			end
		end
	end

	BaseClass.Think( self, pl )
	
end

--[[---------------------------------------------------------
   Called after a game loaded or reloaded
-----------------------------------------------------------]]
function GM:HorrorStoryReady()

	GAMEMODE.gameDone = false
	GAMEMODE.devMode = false
	
	util.AddNetworkString( "GameCompleted" )
	util.AddNetworkString( "HorrorStoryNotify" )
	util.AddNetworkString( "HorrorStoryHelp" )
	util.AddNetworkString( "HorrorStory_ServerSettings" )
	util.AddNetworkString( "HorrorStory_AdminCommand" )
	
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