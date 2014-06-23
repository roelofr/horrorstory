--[[---------------------------------------------------------
	{TMG} Horror Story - Shared
-----------------------------------------------------------]]

include( "sh_messages.lua" )
include( "sh_openplugins.lua" )
include( "sh_vgui.lua" )
include( "player_class/player_horrorstory.lua" )

--
-- Make BaseClass available
--
DEFINE_BASECLASS( "gamemode_base" )

GM.Name 	= "Horror Story"
GM.Author 	= "Roelof"
GM.Email 	= "roelof@tmg-clan.com"
GM.Website 	= "www.tmg-clan.com"

--[[
	OpenPlugins
]]--
if SERVER then
	AddCSLuaFile( "sh_openplugins.lua" )
end
include( "sh_openplugins.lua" )

function GM:GetOfficialMaps()
	return {
		"death_of_the_dream3",
		"death_of_the_dream",
		"death_of_the_dream2",
		"death_of_the_dream3",
		"gm_hellsresort",
		"nightmansion",
		"nightmansion2",
		"scary_united_coop",
		"gm_nightmare_church_rc3",
		"sm_nightville_complete_v2",
		"gm_deathhouse",
		"gm_hellsprison",
		"oneordinarynightmare",
		"ineluctable_ordeal"
	}
end