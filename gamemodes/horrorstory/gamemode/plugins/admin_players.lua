local PLUGIN = {}

PLUGIN.Module = "horrorstory.settings.settingstab"
PLUGIN.Category = "Settings"
PLUGIN.Title = "Playerlist"
PLUGIN.Icon = "icon16/lock_edit.png"
PLUGIN.Realm = PLUGIN_CLIENT
PLUGIN.Priority = 99

function PLUGIN:Create(left, right)
	if not LocalPlayer():IsAdmin() then return end
	
	self.CurrentMap = nil
	
	local _plug = self
	
	self.Frame = vgui.Create( "DFrame", left )
	self.Frame:Dock( TOP )
	self.Frame:SetTall( 200 )
	self.Frame:ShowCloseButton( false )
	self.Frame:SetTitle( "Player list" )
	self.Frame:SetZPos( 400 )
	
			
	self.playerList = vgui.Create("DListView", self.Frame )
	self.playerList:Dock( FILL )
	self.playerList:DockMargin( 6, 10, 6, 3 )
	self.playerList:SetMultiSelect( false )
	
	local c1 = self.playerList:AddColumn( "UniqueID" )
	local c2 = self.playerList:AddColumn( "Name" )
	local c3 = self.playerList:AddColumn( "Steam ID" )
	
	c1:SetMaxWidth( 110 )
	c1:SetMinWidth( 40 )
	
	c3:SetMaxWidth( 140 )
	c3:SetMinWidth( 90 )
	
	for _, pl in pairs( player.GetHumans() ) do
		self:AddPlayer( pl )
	end
	
end

function PLUGIN:AddPlayer( ply )

	local _mapPicker = self

	local line = self.playerList:AddLine( ply:UniqueID(), ply:Nick(), ply:SteamID() )
	line.Player = ply
	line.OnRightClick = function( panel )
		if not panel.Player or not IsValid( panel.Player ) then return end
		
		local _ply = panel.Player
		
		local menu = DermaMenu()
		menu:AddOption( "Spawn", function() _mapPicker:PlyAct( _ply, "spawn" ) end )
		menu:AddOption( "Slay", function() _mapPicker:PlyAct( _ply, "slay" ) end )
		menu:AddSpacer()
		menu:AddOption( "Disable flashlight", function() _mapPicker:PlyAct( _ply, "flashlight-off" ) end )
		menu:AddOption( "Disable noclip", function() _mapPicker:PlyAct( _ply, "noclip-off" ) end )
		menu:AddSpacer()
		menu:AddOption( "Kick", function() _mapPicker:PlyAct( _ply, "kick" ) end )
		menu:AddSpacer()
		menu:AddOption( "Copy", function() if IsValid( _ply ) then SetClipboardText( _ply:Nick() .. " <" .. _ply:SteamID() .. ">" ) end end )
		menu:Open()
	end
end

function PLUGIN:PlyAct( ply, act )
	if IsValid( ply ) then
		net.Start( "HorrorStory_AdminCommand" )
			net.WriteString( act )
			net.WriteEntity( ply )
		net.SendToServer()
	end
end

openPlugins:Add( PLUGIN )