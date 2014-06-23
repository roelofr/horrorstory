--[[---------------------------------------------------------
	{TMG} Horror Story - Player functions
-----------------------------------------------------------]]

--
-- Make BaseClass available
--
DEFINE_BASECLASS( "gamemode_base" )

--[[---------------------------------------------------------
   Name: gamemode:PlayerSpawn( )
   Desc: Called when a player spawns
-----------------------------------------------------------]]
function GM:PlayerSpawn( pl )

	player_manager.SetPlayerClass( pl, "player_horrorstory" )

	BaseClass.PlayerSpawn( self, pl )
	
end

--[[---------------------------------------------------------
   Name: gamemode:PlayerShouldTakeDamage
   Return true if this player should take damage from this attacker
   Note: This is a shared function - the client will think they can 
	 damage the players even though they can't. This just means the 
	 prediction will show blood.
-----------------------------------------------------------]]
function GM:PlayerShouldTakeDamage( ply, attacker )

	if attacker:IsValid() && attacker:IsPlayer() then
		return gamemode.Call( "GetSetting", "PlayersHurtPlayers" )
	end
	
	-- Default, let the player be hurt
	return true

end


--[[---------------------------------------------------------
   Called once on the player's first spawn
-----------------------------------------------------------]]
function GM:PlayerInitialSpawn( ply )

	-- Say hello to our new player
	timer.Simple( 1, function()
		if not IsValid( pl ) then return end
		if GAMEMODE.devMode then
			gamemode.Call( "SendMessage", pl, 10, "red", "WARNING! You have joined the development server!" )
			gamemode.Call( "SendMessage", pl, 10, "red", "There's a high chance things won't work as expected or that the map randomly reloads" )
		else
			if table.HasValue( gamemode.Call("GetOfficialMaps"), game.GetMap() ) then
				gamemode.Call( "SendMessage", pl, 10, "green", "You're playing an official Horror Story map." )			
			end
			gamemode.Call( "SendMessage", pl, 10, "green", "Welcome to Horror Story on " .. GetHostName() .. "." )
		end
	end )

	BaseClass.PlayerInitialSpawn( self, ply )
	
end

--[[---------------------------------------------------------
   Called when the player tries to switch his flashlight
-----------------------------------------------------------]]
function GM:PlayerSwitchFlashlight( pl, onoff )
	if gamemode.Call( "GetSetting", "enableFlashlights" ) then
		return true
	else
		return !onoff or not pl:HasWeapon( "weapon_coflantern" )
	end
end

--[[---------------------------------------------------------
   Called when some bastard wants to noclip
-----------------------------------------------------------]]
function GM:PlayerNoClip( pl )
	if gamemode.Call( "GetSetting", "enableNoclipForAdmins" ) and pl:IsAdmin() then
		return true
	elseif pl:GetMoveType() == MOVETYPE_NOCLIP then
		return true
	else
		return false
	end
end

--[[---------------------------------------------------------
   Show the search when f1 is pressed
-----------------------------------------------------------]]
function GM:ShowHelp( ply )

	net.Start( "HorrorStoryHelp" )
	net.Send( ply )
	
end