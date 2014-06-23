local PLUGIN = {}

PLUGIN.Module = "horrorstory.fixes"
PLUGIN.Realm = PLUGIN_SERVER
PLUGIN.AutoLoad = true

function PLUGIN:Think()
	
	if not self.LastThink then self.LastThink = RealTime() + 4 end
	
	if self.LastThink > RealTime() then return end
	
	self.LastThink = RealTime() + 4
	
	local res = ents.FindInSphere( Vector( 227, 291, 108 ), 128 )
	
	for _, ent in pairs( res ) do
		if IsValid( ent ) and string.sub( ent:GetClass(), 0, 5 ) == "prop_" then
			ent:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
		end
	end
end

function PLUGIN:Init()

	print( "Init" )
	
	if not game.GetMap() == "oneordinarynightmare" then return end

	local HookName = tostring( math.random() * 100 ) .. "Think"
	
	local _buttSeks = self
	
	hook.Add( "Think", HookName, function()
		_buttSeks:Think()
	end )
	
end

openPlugins:Add( PLUGIN )