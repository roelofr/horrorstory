local PLUGIN = {}

PLUGIN.Module = "horrorstory.settings"
PLUGIN.Category = "Settings"
PLUGIN.Title = "HUD Customization"
PLUGIN.Icon = "icon16/color_swatch.png"
PLUGIN.Realm = PLUGIN_CLIENT
PLUGIN.HUDIcons = {"angry","cool","firstaid_1","firstaid_2","firstaid_3","firstaid_4","happy","hysterical","laugh","pirate","sad","shock","surprise"}

function PLUGIN:Create(left, right)
	if not LocalPlayer():IsAdmin() then return end
	
	local _plug = self
	
	self.Frame = vgui.Create( "DFrame", left )
	self.Frame:Dock( TOP )
	self.Frame:SetTall( 200 )
	self.Frame:ShowCloseButton( false )
	self.Frame:SetTitle( "Server settings" )
	
	self:AddLabel( "Healthbar" )
	
	local _, field = self:AddCheckbox( form, "Visibility", "Show healthbar", "HealthBarVisible" )
	
	if gamemode.Call( "GetServerSetting", "overrideHideHUD" ) then
		field.OnChange = function() end
		field:SetChecked( false )
		field:SetDisabled( true )
	end
	
	local _, field = self:AddSelect( form, "Texture", "HealthBarIcon", self.HUDIcons )
	
	if gamemode.Call( "GetServerSetting", "overrideHUDTexture" ) then
		field.OnSelect = function() end
		field:ChooseOption( gamemode.Call( "GetServerSetting", "defaultHUDTexture" ) )
		field:SetDisabled( true )
	end
	
	self:AddNumberWang( form, "Opacity", "HealthBarOpac", 0, 255 )
	
	
	local k = self.Frame:GetChildren()
	local h = 0
	for _, x in pairs( k ) do
		x:SizeToContentsY()
		h = h + x:GetTall()
	end
	self.Frame:SetTall( h )	
end

function PLUGIN:AddLabel( text )
	
	local left = vgui.Create( "DLabel", self.Frame )
	left:SetText( text )
	left:DockMargin( 10, 10, 10, 0 )
	left:Dock( TOP )
	left:SetFont( "DermaLarge" )
	
end

function PLUGIN:AddCheckbox( form, text, label, setting )
	
	local left = vgui.Create( "DLabel", form )
	left:SetText( text )
	
	local right = vgui.Create( "DCheckBoxLabel", form )
	right.OnChange = function( self, value )
		gamemode.Call( "SetClientSetting", setting, Either( value, true, false ) )
	end
	right:SetChecked( gamemode.Call( "GetClientSetting", setting ) )
	right:SetText( label )
	right:Dock( FILL )
	
	self:AddField( left, right )
	
	return left, right
end

function PLUGIN:AddNumberWang( form, text, setting, min, max )
	
	local left = vgui.Create( "DLabel", form )
	left:SetText( text )
	
	local right = vgui.Create( "Slider", form )
	
	right:SetMin( min )
	right:SetMax( max )
	right:SetDecimals( 0 )
	
	right:SetValue( gamemode.Call( "GetClientSetting", setting ) )
	right:Dock( FILL )
	
	right.OnValueChanged = function( self, value )
		gamemode.Call( "SetClientSetting", setting, value )
	end
	
	self:AddField( left, right )
	
	return left, right
end

function PLUGIN:AddSelect( form, text, setting, options )
	
	local left = vgui.Create( "DLabel", form )
	left:SetText( text )
	
	local right = vgui.Create( "DComboBox", form )
	right.OnSelect = function( self, index, value, data )
		gamemode.Call( "SetClientSetting", setting, value )
	end
	for _, entry in ipairs( options ) do
		right:AddChoice( entry )
	end
	right:ChooseOption( gamemode.Call( "GetClientSetting", setting ) )
	right:Dock( FILL )
	
	self:AddField( left, right )
	
	return left, right
end

function PLUGIN:AddField( left, right )
	local Panel = vgui.Create( "DSizeToContents", self.Frame )
--	Panel.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "CategoryButton", panel, w, h ) end
	Panel:SetSizeX( false )
	Panel:Dock( TOP )
	Panel:DockPadding( 10, 10, 10, 0 );
	Panel:InvalidateLayout()
		
	if ( IsValid( right ) ) then
	
		left:SetParent( Panel )
		left:Dock( LEFT )
		left:InvalidateLayout( true )
		left:SetSize( 100, 20 )
		
		right:SetParent( Panel )
		right:SetPos( 110, 0 )
		right:InvalidateLayout( true )

	elseif ( IsValid( left ) ) then
	
		left:SetParent( Panel )
		left:Dock( TOP )

	end
end

openPlugins:Add( PLUGIN )