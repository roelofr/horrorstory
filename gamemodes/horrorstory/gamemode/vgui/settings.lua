--[[

	Settings,
	Main screen overlay for the game's settings

]]

PANEL = {}
function PANEL:Init( )
	if _G.hsSettingsPanel and IsValid( _G.hsSettingsPanel ) then
		_G.hsSettingsPanel:Remove()
	end
	
	_G.hsSettingsPanel = self
	
	self.nav = nil
	
	self.container = nil
	
	self.left = nil
	self.right = nil
	
	self.btnClose:Remove()
	self.btnMaxim:Remove()
	self.btnMinim:Remove()
	self.lblTitle:Remove()
	
	self:SetMouseInputEnabled( true )
	self:SetKeyboardInputEnabled( true )
	
	self:CreatePanels()
	
	self:InvalidateLayout( true )
	
	self:MakePopup()
end
function PANEL:Close()
	self:Remove()
end
function PANEL:CleanUp()
	self.left:Clear()
	self.right:Clear()
end
function PANEL:CreatePanels()
	-- Kill the spacing
	self:DockPadding( 0, 0, 0, 0 )

	local _c = self
		
	self.nav = vgui.Create( "DMenuBar", self )
	
	local b = self.nav:Add( "DButton" )
	b:SetText( "Close" )
	b:Dock( LEFT )
	b:DockMargin( 5, 0, 0, 0 )
	b:SetIsMenu( true )
	b:SetDrawBackground( false )
	b:SizeToContentsX( 16 )
	b.DoClick = function() _c:Close() end
	
	local lbl = "Horror Story"
	local M = self.nav:AddOrGetMenu( lbl )
		local c = nil
		for _, pnl in pairs( self.nav:GetChildren() ) do
			if pnl:GetTable().ClassName == "DButton" then
				c = pnl
			end
		end
		c:Dock( RIGHT )
		c:DockMargin( 5, 0, 5, 0 )
	
	self.container = vgui.Create( "DPanel", self )
	self.container:Dock( FILL )
	self.container:SetDrawBackground( false )
	
	local marg = math.min( 30, ScrW() / 0.02, ScrH() / 0.03 )
	self.container:DockPadding( marg, marg, marg, marg )
	
	self.left = vgui.Create( "DPanel", self.container )
	self.left:Dock( LEFT )
	self.left:SetDrawBackground( false )
	self.left:DockMargin( 0, 0, marg*0.6, 0 )
	
	self.right = vgui.Create( "DPanel", self.container )
	self.right:Dock( FILL )
	self.right:SetDrawBackground( false )
	self.right:DockMargin( marg*0.6, 0, 0, 0 )
	
	
	
	self.left.OnChildAdded = function( self, panel )
		panel:DockMargin( 0, 0, 0, 12 )
	end
	
	
	self.right.OnChildAdded = function( self, panel )
		panel:DockMargin( 0, 0, 0, 12 )
	end
	
	self:LoadPanelsFromPlugin()
	
	self:DefaultContent( self.left, self.right )
end
function PANEL:LoadPanelsFromPlugin()
	local plugs = openPlugins:GetPlugins( "horrorstory.settings" )
	
	local seen = {}
	
	for _, plugin in pairs( plugs ) do
		
		-- No invalid plugins
		if not plugin.Category or not plugin.Title then continue end
		
		local seenName = plugin.Category .. "->" .. plugin.Title
		
		if table.HasValue( seen, seenName ) then continue end
		table.insert( seen, seenName )
		
		local _c, _m = self, plugin
		
		local M = self.nav:AddOrGetMenu( plugin.Category )
		local opt = M:AddOption( plugin.Title, function() _c:OpenCategory( _m.Category, _m.Title ) end )
		if plugin.Icon then
			opt:SetIcon( plugin.Icon )
		end
	end
end
function PANEL:OpenCategory( cat, title )
	local plugs = openPlugins:GetPlugins( "horrorstory.settings" )
		
	self:CleanUp()
	
	local drawn = false
	
	for _, plugin in pairs( plugs ) do
		
		-- No invalid plugins
		if not plugin.Category or not plugin.Title then continue end
		
		if plugin.Category != cat or plugin.Title != title then continue end
		
		if self:OpenPlugin( plugin ) then drawn = true end
	end
	
	if not drawn then
		self:CleanUp()
		self:DefaultContent( self.left, self.right )
	end
end
function PANEL:OpenPlugin( plugin )
	
	-- Sandbox the call
	local ok, ret = pcall( function( a, b, c )
		a:Create( b, c )
	end, plugin, self.left, self.right )
	
	if not ok then
		Derma_Message( "One of the plugins responsible for this tab's content has failed to load and won't be shown.\nError: " .. ret, "Error", "Okay" )
		return false
	else
		return true
	end
end
function PANEL:DefaultContent( left, right )
	
	local plugs = openPlugins:GetPlugins( "horrorstory.settings.frontpage" )
	if plugs == nil or table.Count( plugs ) == 0 then return end
	
	for _, plugin in pairs( plugs ) do
		
		-- No invalid plugins
		if not plugin.Title then continue end
		
		self:OpenPlugin( plugin )
	end
end
function PANEL:NoContentForModule( left, right)

	local FrameR = vgui.Create( "DFrame", left )
	FrameR:Dock( TOP )
	FrameR:ShowCloseButton( true )
	FrameR:SetTitle( "No plugin response" )
	FrameR:SetHeight( 40 + 20 + 4 )
	
	local textLabel = vgui.Create( "DLabel", FrameR )
	textLabel:Dock( FILL )
	textLabel:SetText( "The requested menu item didn't create any content, so you've been redirected to the homepage. Perhaps you're lacking permissions?" );
	textLabel:SetWrap( true )
	
end
function PANEL:Close()
 	self:Remove( )
end
function PANEL:Paint( )
	--Blur the background, we just don't care
	Derma_DrawBackgroundBlur( self, SysTime() - 64 )
	
	local mat = Material( "horrorstory/logo_settings.png" )
	
	surface.SetDrawColor( Color( 255, 255, 255, 50 ) )
	surface.SetMaterial( mat )
	
	local mul = math.min( math.min( ScrW() - 128, 1024 ) / 1024, math.min( ScrH() - 128, 512 ) / 512 )
	
	surface.DrawTexturedRect( ( ScrW() - 1024 * mul ) / 2, ( ScrH() - 512 * mul ) / 2, 1024 * mul, 512 * mul )
	
end
function PANEL:Think()
	if ( input.WasKeyPressed( KEY_ESCAPE ) or input.IsKeyDown( KEY_ESCAPE ) ) and not self._Removing then
		CloseDermaMenus()
		self._Removing = true
		self:Remove()
	end
end
function PANEL:PerformLayout( )
	self:SetPos( 0, 0 )
	self:SetSize( ScrW(), ScrH() )
	
	if self.left and IsValid( self.left ) then
		self.left:SetWide( math.max( 300, ScrW() / 3 ) )
	end
end
vgui.Register( "horrorstory_settings", PANEL, "DFrame" )