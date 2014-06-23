local PLUGIN = {}

PLUGIN.Module = "horrorstory.settings.settingstab"
PLUGIN.Category = "Settings"
PLUGIN.Title = "Server settings"
PLUGIN.Icon = "icon16/lock_edit.png"
PLUGIN.Realm = PLUGIN_CLIENT
PLUGIN.HUDIcons = {"angry","cool","firstaid_1","firstaid_2","firstaid_3","firstaid_4","happy","hysterical","laugh","pirate","sad","shock","surprise"}

function PLUGIN:Create(left, right)
	if not LocalPlayer():IsAdmin() then return end
	
	local _plug = self
	
	self.FrameContainer = vgui.Create( "DFrame", left )
	self.FrameContainer:Dock( TOP )
	self.FrameContainer:SetTall( 300 )
	self.FrameContainer:ShowCloseButton( false )
	self.FrameContainer:SetTitle( "Server settings" )
	
	self.Frame = vgui.Create( "DScrollPanel", self.FrameContainer )
	self.Frame:Dock( FILL )
	
	self:AddLabel( "Gameplay" )
		
	self:AddCheckbox( form, "Flashlights", "Enable flashlights", "enableFlashlights" )
	
	self:AddCheckbox( form, "No-clip", "Allow admin noclip", "enableNoclipForAdmins" )
	
	local l, r = self:AddCheckbox( form, "Collision", "Collide with ragdolls", "ragdollCollision" )
	
	r:SetDisabled( true )
	
	self:AddLabel( "Overrides" )
	
	self:AddCheckbox( form, "Hide healthbar", "Always hide hud", "overrideHideHUD" )
	
	self:AddCheckbox( form, "Force healthbar", "Force to default texture", "overrideHUDTexture" )
	
	self:AddLabel( "Defaults" )
	
	self:AddSelect( form, "Default healthbar", "defaultHUDTexture", self.HUDIcons )
	self:AddLabel( " " )
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
		gamemode.Call( "SetServerSetting", setting, Either( value, true, false ) )
		gamemode.Call( "SaveServerSettings" )
	end
	right:SetChecked( gamemode.Call( "GetServerSetting", setting ) )
	right:SetText( label )
	right:Dock( FILL )
	
	self:AddField( left, right )
	
	return left, right
end

function PLUGIN:AddNumberWang( form, text, setting, min, max )
	
	local left = vgui.Create( "DLabel", form )
	left:SetText( text )
	
	local right = vgui.Create( "DNumberScratch", form )
	
	right:SetMin( min )
	right:SetMax( max )
	right:SetShouldDrawScreen( false )
	right:SetDecimals( 0 )
	
	right:SetMinMax( min, max )
	right:SetValue( gamemode.Call( "GetServerSetting", setting ) )
	right:Dock( FILL )
	
	right.OnValueChanged = function( self, value )
		gamemode.Call( "SetServerSetting", setting, value )
		gamemode.Call( "SaveServerSettings" )
	end
	
	self:AddField( left, right )
	
	return left, right
end

function PLUGIN:AddSelect( form, text, setting, options )
	
	local left = vgui.Create( "DLabel", form )
	left:SetText( text )
	
	local right = vgui.Create( "DComboBox", form )
	right.OnSelect = function( self, index, value, data )
		gamemode.Call( "SetServerSetting", setting, value )
		gamemode.Call( "SaveServerSettings" )
	end
	for _, entry in ipairs( options ) do
		right:AddChoice( entry )
	end
	right:ChooseOption( gamemode.Call( "GetServerSetting", setting ) )
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