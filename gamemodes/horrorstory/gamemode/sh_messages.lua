--[[
	sh_messages.lua
	Sends messages from the server to the client
]]--

if SERVER then
	function GM:SendMessage( ... )
		local args = { ... }
		local target = nil
		local data = { ["text"] = "", ["color"] = "", ["time"] = 7 }
		
		if type( args ) != "table" or table.Count( args ) == 0 then return end
		
		if type( args[1] ) == "Player" or ( type( args[1] ) == "table" and type( args[1][1] ) == "Player" ) then
			target = args[1]
			table.remove( args, 1 )
		end
		if type( args[1] ) == "number" then
			data.time = args[1]
			table.remove( args, 1 )
		end
		if type( args[1] ) == "string" and table.HasValue( {"blue","red","yellow","green"}, args[1] ) then
			data.color = args[1]
			table.remove( args, 1 )
		end
		
		if table.Count( args ) == 0 then return end
		
		for rownum, arg in pairs( args ) do
			if type( arg ) == "Player" and arg:IsValid() then
				data.text = data.text .. arg:Nick()
			else
				data.text = data.text .. tostring( arg )
			end
		end
		net.Start( "HorrorStoryNotify" )
			net.WriteTable( data )
		if target != nil then
			net.Send( target )
		else
			net.Broadcast()
		end
	end
else

end