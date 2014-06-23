--[[
	Admin actions
]]--

net.Receive( "HorrorStory_AdminCommand", function( length, ply )
	if not IsValid( ply ) or not ply:IsPlayer() or not ply:IsAdmin() then return end
	
	local act = net.ReadString()
	
	print( "Act = " .. act )
	
	-- Change level
	if act == "map" then
		local map = net.ReadString()
		RunConsoleCommand( "changelevel", map )
		
	-- Slay
	elseif act == "slay" then
		local entity = net.ReadEntity()
		pcall( function( a )
			a:Kill()
		end, entity )
		
	-- Repsawn
	elseif act == "spawn" then
		local entity = net.ReadEntity()
		pcall( function( a )
			a:Spawn()
		end, entity )
		
	-- Disable noclip
	elseif act == "noclip-off" then
		local entity = net.ReadEntity()
		pcall( function( a )
			a:SetMoveType( MOVETYPE_WALK )
		end, entity )
		
	-- Flashlight off
	elseif act == "flashlight-off" then
		local entity = net.ReadEntity()
		pcall( function( a )
			a:Flashlight( false )
			a:Give( "weapon_coflantern" )
		end, entity )
		
	-- Kick
	elseif act == "kick" then
		local entity = net.ReadEntity()
		pcall( function( a, b )
			a:Kick( "Kicked by " .. b:Nick() )
		end, entity, ply )
	end
end )