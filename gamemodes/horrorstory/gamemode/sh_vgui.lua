--[[

VGUI control,
holds the hud

]]
local fileList = {
	"vgui/notifications.lua",
	"vgui/hud.lua",
	"vgui/settings.lua"
}
if SERVER then
	AddCSLuaFile( "sh_vgui.lua" )
	for _, url in ipairs( fileList ) do
		AddCSLuaFile( url )
	end
else
	for _, url in ipairs( fileList ) do
		include( url )
	end
end