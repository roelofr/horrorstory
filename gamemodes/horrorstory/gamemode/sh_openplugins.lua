--[[
	sh_openplugins.lua
	openplugins plugin system
]]--

-- Only register openPlugins if it's not yet created

local dev = true

if not _G.openPlugins or not _G.openPlugins._isOP or dev then
	local openPlugins = {}
	openPlugins._plugins = {}
	openPlugins._isOP = true
	
	openPlugins._intl = {
		-- These are always ignored, allowing you to add the keys to your plugin.
		ignoredKeys = {"module","realm","category","title","icon","name","usage","permissions","call"}
	}
	
	-- Define constants
	_G.PLUGIN_CLIENT = "client"
	_G.PLUGIN_SERVER = "server"
	_G.PLUGIN_SHARED = "shared"
	_G.PLUGIN_NONE = "none"
	
	--[[---------------------------------------------------------
	   Name: openPlugins:makeValidModule( string )
	   Desc: Transforms a raw module name to a valid one
	-----------------------------------------------------------]]
	function openPlugins:makeValidModule( str )
		str = string.gsub( str, "([^%w%._%-]+)", "" )
		str = string.gsub( str, "^([%d]+)", "" )
		
		return Either( string.len( str ) == 0, false, str )
	end
	
	--[[---------------------------------------------------------
	   Name: openPlugins:Add( plugin )
	   Desc: Adds a plugin to the plugin table
	   Args:	plugin		table	The plugin to be added, must
									contain a Module key to be
									assigned to.
	-----------------------------------------------------------]]
	function openPlugins:Add( plugin )
		
		local pluginDummy = { ["Realm"] = PLUGIN_NONE, ["Priority"] = 30, ["Module"] = "" }
		
		table.Merge( pluginDummy, plugin )
		plugin = pluginDummy
		
		--Get the module and check if it's valid
		plugin.Module = self:makeValidModule( Either( plugin.Module != nil, plugin.Module, "" ) )
		
		-- Check if we still have a module name
		if not plugin.Module then return end
		
		-- We need to pass certain filters
		local pass = plugin.Realm == PLUGIN_SHARED or ( SERVER and plugin.Realm == PLUGIN_SERVER ) or ( CLIENT and plugin.Realm == PLUGIN_CLIENT ) or plugin.Realm == true
		
		-- Add the file to the download queue if it's ment for the client (or if it's shared)
		if SERVER and ( plugin.Realm == PLUGIN_CLIENT or plugin.Realm == PLUGIN_SHARED ) and self._intl.cfile then
			AddCSLuaFile( self._intl.cfile )
		end
		
		-- Abort if we didn't pass the realm filter
		if not pass then return end
		
		-- Make sure the module key exists
		if not self._plugins[ plugin.Module ] then self._plugins[ plugin.Module ] = {} end
		
		if plugin.AutoHook then
			self:InitPlugin( plugin )
		end
		
		if plugin.AutoLoad or plugin.AutoInit then
			if plugin.Init and type( plugin.Init ) == "function" then
				pcall(function() plugin:Init() end)
			end
		end
		
		plugin.HookName = "OpenPlugins_" .. table.Count( plugin ) .. "." .. table.Count( self._plugins[ plugin.Module ] )
		
		table.insert( self._plugins[ plugin.Module ], plugin )
		
		return plugin
	end
	
	--[[---------------------------------------------------------
	   Name: openPlugins:InitPlugin( plugin )
	   Desc: Hooks up a plugin to all available hooks (internal)
	   Args:	plugin		table	The plugin to be loaded
	-----------------------------------------------------------]]
	function openPlugins:InitPlugin( plugin )
		if not plugin.Module then return end
		if not self._plugins[ plugin.Module ] then return end
		if plugin.PluginHooked then return end
		
		-- Make sure there's a unique identifier
		local keyModifier = "openPlugins_" .. plugin.Module .."_" .. table.Count( self._plugins[ plugin.Module ] ) .. "_"
		
		local _p = plugin
		
		for key, value in pairs( plugin ) do
			
			-- Skip all non-functions
			if type( value ) ~= "function" then continue end
			
			-- If a key doesn't start with a-z or A-Z then we skip it.
			if not string.match( key, "^[a-zA-Z]" ) then continue end
			
			-- Skip all reserved functions
			if table.HasValue( self._intl.ignoredKeys, string.lower( key ) ) then continue end
			
			local _p, _k = plugin, key;
			
			if not self.BoundHooks then self.BoundHooks = {} end
			if not self.BoundHooks[key] then self.BoundHooks[key] = {} end
			
			table.insert( self.BoundHooks[key], keyModifier .. key )
			
			-- Add it.
			hook.Add( key, keyModifier .. key, function(a,b,c,d)
				pcall( value, plugin, a, b, c, d )
			end )
		end
		
		-- We're hooked now, save this so we can never spam this
		plugin.PluginHooked = true
	end
	
	--[[---------------------------------------------------------
	   Name: openPlugins:FlushHooks()
	   Desc: Flushes all the hooks, clearing old plugins
	-----------------------------------------------------------]]
	function openPlugins:FlushHooks()
	
		if not self.BoundHooks then return end
	
		local _allHooks = self.BoundHooks
		for hookName, d in pairs( _allHooks ) do
			for _, name in pairs( d ) do
				hook.Remove( hookName, name )
			end
		end
	end

	--[[---------------------------------------------------------
	   Name: openPlugins:GetPlugins( string )
	   Desc: Gets a copy of all the plugins in this module
	-----------------------------------------------------------]]
	function openPlugins:GetPlugins( mod )
		-- Safely get the module name
		mod = Either( mod != nil, mod, "" )
		
		-- Strip all illegal characters
		mod = self:makeValidModule( mod )
		
		-- If the module name was set to false, abort
		if not mod then return nil end
		
		-- Skip this if the mod doesn't exist
		if not self._plugins[ mod ] then return nil end
		
		-- Make a non-recursive copy
		local out = {}
		
		-- Loop through all the keys and add them to the empty table
		for _,v in pairs( self._plugins[ mod ] ) do
			table.insert( out, v )
		end
		
		-- Order by priority
		table.sort( out, function( a, b )
			if a.Priority > b.Priority then
				return 1
			elseif a.Priority < b.Priority then
				return -1
			else
				return 0
			end
		end )
		
		-- Return it
		return out
	end

	--[[---------------------------------------------------------
	   Name: openPlugins:GetAll( )
	   Desc: Returns a copy of the entire plugin table.
	-----------------------------------------------------------]]
	function openPlugins:GetAll()
		-- Make a non-recursive copy
		local out = {}
		
		-- Loop through all the keys and add them to the empty table
		for k,v in pairs( self._plugins ) do
			out[k] = {}
			-- We don't want people to be able to modify a module table
			for k2, v2 in pairs( v ) do
				out[k2] = v2
			end
		end
		
		-- Return it
		return out
	end
	
	--[[---------------------------------------------------------
	   Name: openPlugins:AddDirectory( path, recursive, log )
	   Desc: Adds all the files from a directory.
	   Args:	path		string	The path, from /lua
				recursive	boolean	Loop into subdirectories
				log			boolean	Log indexing to console
	-----------------------------------------------------------]]
	function openPlugins:AddDirectory( path, recursive, log )
		recursive = ( recursive == true )
		log = ( log == true )
		
		local f, d = file.Find( path .. "/*", "LUA" )
		for _, luafile in pairs( f ) do
			if string.Right( luafile, 4 ) == ".lua" and file.Exists( path .. "/" .. luafile, "LUA" ) then
				self._intl.cfile = path .. "/" .. luafile
				include( path .. "/" .. luafile )
			end
		end
		if recursive then
			for _, directory in pairs( d ) do
				if string.Left( directory, 1 ) != "_" and file.IsDir( path .. "/" .. directory, "LUA" ) then
					self:AddDirectory( path .. "/" .. directory, true, log )
				end
			end
		end
	end
	
	_G.openPlugins = openPlugins
end