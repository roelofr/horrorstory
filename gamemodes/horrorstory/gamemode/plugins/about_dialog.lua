local PLUGIN = {}

PLUGIN.Module = "horrorstory.settings"
PLUGIN.Category = "Horror Story"
PLUGIN.Title = "About"
PLUGIN.Icon = "icon16/information.png"
PLUGIN.Realm = PLUGIN_CLIENT

function PLUGIN:Create(left, right)
	self.FrameL = vgui.Create( "DFrame", left )
	self.FrameL:Dock( TOP )
	self.FrameL:ShowCloseButton( false )
	self.FrameL:SetTitle( "Horror Story" )
	
	self.text = vgui.Create( "DLabel", self.FrameL )
	self.text:Dock( TOP )
	self.text:DockPadding(5,5,5,5)
	self.text:SetText( "Horror Story 2.0\n\nCreated by: Roelof\n\nFeaturing:\n - Cry of Fear lantern by LordiAnders\n - Lighter by Mr. Sunabouzu\n\nAnd a personal thanks to you, for playing this and for reading this about." )
	
	local k = self.FrameL:GetChildren()
	local h = 0
	for _, x in pairs( k ) do
		x:SizeToContentsY( 10 )
		h = h + x:GetTall()
	end
	self.FrameL:SetTall( h )
	
	self.FrameR = vgui.Create( "DFrame", right )
	self.FrameR:Dock( FILL )
	self.FrameR:ShowCloseButton( false )
	self.FrameR:SetTitle( "Changelog" )
	
	local browser = vgui.Create( "DHTML", self.FrameR )
	browser:Dock( FILL )
	browser:OpenURL( "http://steamcommunity.com/sharedfiles/filedetails/changelog/124828021" )
end

openPlugins:Add( PLUGIN )