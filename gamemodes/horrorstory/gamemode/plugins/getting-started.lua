local PLUGIN = {}

PLUGIN.Module = "horrorstory.settings.frontpage"
PLUGIN.isDefault = true
PLUGIN.Title = "Getting started"
PLUGIN.Realm = PLUGIN_CLIENT
PLUGIN.Priority = 6

function PLUGIN:Create(left, right)
	self.FrameR = vgui.Create( "DFrame", left )
	self.FrameR:Dock( TOP )
	self.FrameR:ShowCloseButton( false )
	self.FrameR:SetTitle( self.Title )
	self.FrameR:SetHeight( 140 + 20 + 4 )
	
	local richText = vgui.Create( "RichText", self.FrameR )
	richText:Dock( FILL )
	richText:AppendText( "Welcome to Horror Story,\n\nIn this menu, you can set your preferences and the server owners can provide you with any additional services (availability depends on the server).\n\nI hope you have fun in this gamemode, and if you are missing anyhting, make sure to let me know!\n\nRegards,\n\nRoelof" )
end

openPlugins:Add( PLUGIN )