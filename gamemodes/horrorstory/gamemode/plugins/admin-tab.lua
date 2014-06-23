local PLUGIN = {}

PLUGIN.Module = "horrorstory.settings"
PLUGIN.Category = "Settings"
PLUGIN.Title = "Server settings"
PLUGIN.Icon = "icon16/lock_edit.png"
PLUGIN.Realm = PLUGIN_CLIENT

function PLUGIN:Create(left, right)
	local plugs = openPlugins:GetPlugins( "horrorstory.settings.settingstab" )
	
	local seen = {}
	
	local hasErrors = {}
	
	for _, plugin in pairs( plugs ) do
		
		-- No invalid plugins
		if not plugin.Category or not plugin.Title then continue end
		
		-- Sandbox the call
		local ok, ret = pcall( function( a, b, c )
			a:Create( b, c )
		end, plugin, left, right )
		
		if not ok then
			table.insert( hasErrors, ret )
		end
	end
	
	if table.Count( hasErrors ) > 0 then
		Derma_Message( "One of the plugins responsible for this tab's content has failed to load and won't be shown.\nError(s):\n - " .. table.concat( hasErrors, "\n - " ), "Warning", "Ok" )
	end
end

openPlugins:Add( PLUGIN )