AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
	self:SetModel("models/weapons/cof/w_lantern.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
end

function ENT:Use(activator,caller)
	if activator:IsValid() and activator:IsPlayer() then
		if activator:HasWeapon("coflantern") then return end
		activator:Give("coflantern")
		self:Remove()
	end
end

function ENT:OnTakeDamage()
end