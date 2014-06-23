--[[

VGUI control,
holds the hud

]]

local HPHudConvar = CreateClientConVar( "horrorstory_hud_image", "default", { FCVAR_ARCHIVE } )

PANEL = {}
function PANEL:Init( )
	self:SetDrawBackground( false )
	self.font = "DermaLarge"
	self.remeasure = 0
	
	self.textHeight = 0
	
	self.myHeight = 128
	
	self.randomTexture = nil
	
	self.healthbar = Material( "horrorstory/healthbar.png" )
	self.reset = Material( "horrorstory/pixel.png" )
	
	self:InvalidateLayout( true )
end
function PANEL:GetBarTexture()
	local healthTex = string.lower( gamemode.Call( "GetClientSetting", "HealthBarIcon" ) )
	
	if gamemode.Call( "GetServerSetting", "overrideHUDTexture" ) then
		healthTex = string.lower( gamemode.Call( "GetServerSetting", "defaultHUDTexture" ) )
	end
	
	local AvailableBars = { "angry", "cool", "firstaid_1", "firstaid_2", "firstaid_3", "firstaid_4", "happy", "hysterical", "laugh", "pirate", "sad", "shock", "surprise" }
	local barRoot = "horrorstory/bartypes/"
	
	local AvailableConvars = { "default", "random" }
	table.Add( AvailableConvars, AvailableBars )
	
	if not table.HasValue( AvailableConvars, healthTex ) then
		healthTex = "firstaid_4"
	end
	
	return Material( barRoot .. healthTex .. ".png" )
end
function PANEL:Close()
 	self:Remove( )
end
function PANEL:Paint( )
	if not IsValid( LocalPlayer() ) then return end
	
	if not gamemode.Call( "GetClientSetting", "HealthBarVisible" ) then return end
	
	if gamemode.Call( "GetServerSetting", "overrideHideHUD" ) then return end

	local opacity = tonumber( gamemode.Call( "GetClientSetting", "HealthBarOpac" ) )
	
	surface.SetDrawColor( Color( 255, 255, 255, opacity ) )
	surface.SetMaterial( self:GetBarTexture() )
	surface.DrawTexturedRect( 108, 0, 296, 128 )
	
	surface.SetTextColor( Color( 255, 255, 255, opacity ) )
	surface.SetTextPos( 256 + 64, 64 - self.textHeight*0.5 )
	surface.SetFont( self.font )
	surface.DrawText( math.Clamp( LocalPlayer():Health(), 0, 100 ) )
end
function PANEL:PerformLayout( )
	self:SetSize( ScrW(), self.myHeight )
	self:SetPos( -95, ScrH() - self:GetTall() - 5 )
end
function PANEL:Think()
	if self.remeasure < CurTime() then
		self.remeasure = CurTime() + 0.5
		
		self:GetBarTexture()
		
		surface.SetFont( self.font )
		local w, h = surface.GetTextSize( "999" )
		self.textHeight = h
	end
end
vgui.Register( "horrorstory_hud", PANEL, "DPanel" )