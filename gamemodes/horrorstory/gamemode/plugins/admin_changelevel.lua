local PLUGIN = {}

PLUGIN.Module = "horrorstory.settings.settingstab"
PLUGIN.Category = "Settings"
PLUGIN.Title = "Change map"
PLUGIN.Icon = "icon16/lock_edit.png"
PLUGIN.Realm = PLUGIN_CLIENT

PLUGIN.HorrorMaps = nil

function PLUGIN:Create(left, right)
	if not LocalPlayer():IsAdmin() then return end
	
	self.CurrentMap = nil
	
	local _plug = self
	
	self.Frame = vgui.Create( "DFrame", right )
	self.Frame:Dock( FILL )
	self.Frame:SetTall( 200 )
	self.Frame:ShowCloseButton( false )
	self.Frame:SetTitle( "Change level" )
	
			
	self.mapList = vgui.Create("DListView", self.Frame )
	self.mapList:Dock( FILL )
	self.mapList:DockMargin( 6, 10, 6, 3 )
	self.mapList:SetMultiSelect( false )
	
	local c1 = self.mapList:AddColumn( "Type" )
	local c2 = self.mapList:AddColumn( "Name" )
	
	c1:SetMaxWidth( 70 )
	c1:SetMinWidth( 40 )

	self:AddButtons()
	self:InsertMaps()
	
end

function PLUGIN:AddMap( label, name )

	local _mapPicker = self

	local line = self.mapList:AddLine( label, name )
	line.OnSelect = function( panel )
		_mapPicker:SetCurrentMap( panel:GetColumnText( 2 ) )
	end
	
	if name == game.GetMap() then
		line:GetListView():OnClickLine( line, true )
		line:OnSelect()
	end
end

function PLUGIN:SetCurrentMap( name )
	self.CurrentMap = name
	
	if IsValid( self.SwitchButton ) then
		if name == game.GetMap() then
			self.SwitchButton:SetText( "Restart map" )
		else
			self.SwitchButton:SetText( "Switch to " .. name )
		end
		self.SwitchButton:SetDisabled( false )
	end
end

function PLUGIN:SwitchMap()
	if self.CurrentMap == nil then return end
	
	net.Start( "HorrorStory_AdminCommand" )
		net.WriteString( "map" )
		net.WriteString( self.CurrentMap )
	net.SendToServer()
end

function PLUGIN:InsertMaps()
	self.mapList:Clear()
	
	local ded, rest = self:GetMaps()
	
	for _, name in ipairs( ded ) do
		self:AddMap( "Official", name )
	end
	
	if self.ShowAllCheckbox and !self.ShowAllCheckbox:GetChecked() then
		for _, name in ipairs( rest ) do
			self:AddMap( "Other", name )
		end
	end
end

function PLUGIN:GetMaps()

	if self.HorrorMaps == nil then
		self:GetOfficialMaps()
	end
	
	local allMaps, _ = gamemode.Call( "GetServerSetting", "maplist" )
	
	local HSMaps, RestMaps = {}, {}
	
	local currentMap = game.GetMap()
	
	for _, map in ipairs( allMaps ) do
		map = string.gsub( map, "%.bsp$", "" )
	
		if self.HorrorMaps != nil and table.HasValue( self.HorrorMaps, string.lower( map ) ) then
			table.insert( HSMaps, map )
		else
			table.insert( RestMaps, map )
		end
	end
	
	return HSMaps, RestMaps
end

function PLUGIN:AddButtons()

	local _plug = self

	self.SwitchButton = vgui.Create( "DButton", self.Frame )
	self.SwitchButton:SetText( "Switch to ..." )
	self.SwitchButton:SetDisabled( true )
	self.SwitchButton.DoClick = function()
		_plug:SwitchMap()
	end
	
	self.SwitchButton:SetTall( 30 )
	self.SwitchButton:DockMargin( 6, 0, 6, 0 )
	
	self.ShowAllCheckbox = vgui.Create( "DCheckBoxLabel", form )
	self.ShowAllCheckbox.OnChange = function( self, value )
		_plug:InsertMaps()
	end
	self.ShowAllCheckbox:SetText( "Show only official maps" )
	self.ShowAllCheckbox:SetChecked( true )

	local Panel = vgui.Create( "DSizeToContents", self.Frame )
--	Panel.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "CategoryButton", panel, w, h ) end
	Panel:SetSizeX( false )
	Panel:Dock( BOTTOM )
	Panel:DockPadding( 10, 0, 10, 5 );
	Panel:InvalidateLayout()
	
	local left, right = self.SwitchButton, self.ShowAllCheckbox
	
	if ( IsValid( right ) ) then
	
		left:SetParent( Panel )
		left:Dock( LEFT )
		left:InvalidateLayout( true )
		left:SetSize( 210, 20 )
		
		right:SetParent( Panel )
		right:Dock( RIGHT )
		right:InvalidateLayout( true )
	Panel:DockMargin( 0, 5, 0, 0 );
		right:SetSize( 210, 20 )

	elseif ( IsValid( left ) ) then
	
		left:SetParent( Panel )
		left:Dock( TOP )

	end
end

function PLUGIN:GetOfficialMaps()
	self.HorrorMaps = gamemode.Call("GetOfficialMaps")
	if self.HorrorMaps == nil or type( self.HorrorMaps ) != "table" then
		self.HorrorMaps = {}
	end
end

openPlugins:Add( PLUGIN )