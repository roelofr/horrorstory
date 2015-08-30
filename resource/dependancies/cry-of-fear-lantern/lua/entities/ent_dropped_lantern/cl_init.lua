include("shared.lua")
function ENT:Draw()
	self:DrawModel()
end

function ENT:Think()
	local dlight = DynamicLight("d_lantern_"..self:EntIndex())
	if dlight then

	dlight.Pos = self:GetPos()
	dlight.r = 170
	dlight.g = 240
	dlight.b = 250
	dlight.Brightness = 0.01
	dlight.Size = 270
	dlight.DieTime = CurTime() + .01
	dlight.Style = 6
	end
end