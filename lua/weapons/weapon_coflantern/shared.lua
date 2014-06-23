if SERVER then
	-- Add this file from the workshop, so all models are downloaded from Steam
	resource.AddWorkshop("132470017")
end

hook.Add("CalcMainActivity","Lantern_Slapp",function(ply,vel)
	if CLIENT then
	usermessage.Hook("Lantern_SlappC", function(um)
		local ply2 = um:ReadEntity()
		local anim = um:ReadString()
		if not IsValid(ply2) or not ply2:IsPlayer() then return end
		if anim == "1" then
		ply2:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST, true)
		elseif anim == "2" then
		ply2:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_HL2MP_RUN_FAST, false)
		elseif anim == "3" then
		ply2:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_IN_CHAT, true)
		end
	end)
	end
end)

SWEP.ViewModelFOV = 85
SWEP.ViewModel = "models/weapons/cof/v_lantern.mdl"
SWEP.WorldModel = "models/weapons/cof/w_lantern.mdl" 
SWEP.UseHands = false
SWEP.Slot = 0
SWEP.HoldType = "pistol" 
SWEP.PrintName = "Lantern"  
SWEP.Author = "LordiAnders" 
SWEP.Spawnable = true  
SWEP.DrawCrosshair = false
SWEP.Category = "LordiAnders's Weapons" 
SWEP.SlotPos = 0 
SWEP.DrawAmmo = false  
SWEP.Instructions = "Hold E + Attack to drop Attack2 to punch"   
SWEP.Contact = ""  
SWEP.Purpose = "A dim lantern. I should be able to light my way with this" 
SWEP.base = "weapon_base"

SWEP.Primary.Ammo = "none"                                                  
SWEP.Primary.Automatic = false                                     
SWEP.Primary.ClipSize = -1

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.Offset = {
    Pos = {
        Right = 1,
        Forward = -1,
        Up = -16,
    },
    Ang = {
        Right = 0,
        Forward = -5,
        Up = 78,
    },
    Scale = Vector( .5, .5, .5 ),
}

function SWEP:Deploy()
	self:EmitSound("weapons/cof/sleeve_generic"..math.random(1,3)..".wav")
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
	-- Prevention of NULL entity error
	if not self.Owner or not IsValid(self.Owner) then return end
	
	local trace = self.Owner:GetEyeTrace()
	if SERVER then
	self:SendWeaponAnim(ACT_VM_IDLE)
	timer.Simple(0,function()
		-- Prevention of NULL entity error
		if not self.Owner or not IsValid(self.Owner) then return end
		
		if trace.HitPos:Distance(self.Owner:GetShootPos()) <= 75 then
			self.Weapon:SendWeaponAnim( ACT_VM_SWINGHIT )
		else
			self.Weapon:SendWeaponAnim( ACT_VM_SWINGMISS )
		end
	end)
end
if SERVER then
	umsg.Start("Lantern_SlappC")
		umsg.Entity(self.Owner)
		umsg.String("1")
	umsg.End()
end
if SERVER then
timer.Simple(0.26,function()
	-- Prevention of NULL entity error (1/2)
	if not IsValid(self) then return end
	
	-- Prevention of NULL entity error (2/2)
	if not self.Owner or not IsValid(self.Owner) then return end
	
	local trace = self.Owner:GetEyeTrace()
	if trace.HitPos:Distance(self.Owner:GetShootPos()) <= 75 then
		self:EmitSound("weapons/cof/melee_hit.wav")
		if trace.Entity:IsValid() then
			if trace.Entity:IsPlayer() or trace.Entity:IsNPC() then
				trace.Entity:TakeDamage(5,self.Owner)
			end
		end
	else
		self:EmitSound("weapons/cof/sleeve_generic3.wav")
	end
end)
end
self:SetNextSecondaryFire( CurTime() + 1.16 )
end

function SWEP:Initialize()
	self:EmitSound("weapons/cof/weapon_get.wav")
	self:SetWeaponHoldType(self.HoldType)
	if ( SERVER ) then
		self:SetWeaponHoldType(self.HoldType)
	end
end

function SWEP:Think()
	if IsValid(self.Owner) then
		if self.Owner:IsNPC() then self.Owner:StripWeapon(self:GetClass()) return end
		
		if CLIENT then
			-- I know using a spine bone and not a hand bone is a bit silly... But its best suited for the view model
			if !self.Owner:LookupBone("ValveBiped.Bip01_Spine4") then
				return
			end
			local dlight = DynamicLight("lantern_"..self:EntIndex())
			if dlight then

			dlight.Pos = self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_Spine4"))
			dlight.r = 170
			dlight.g = 240
			dlight.b = 250
			dlight.Brightness = 0.01
			dlight.Size = 270
			dlight.DieTime = CurTime() + .01
			dlight.Style = 6
			end
		end
		if SERVER then
			if self.Owner:KeyDown(IN_SPEED) and self.Owner:GetVelocity():Length() > self.Owner:GetWalkSpeed() then
				if SERVER then
					if not self.UserMessageSent then
					umsg.Start("Lantern_SlappC")
						umsg.Entity(self.Owner)
						umsg.String("2")
					umsg.End()
					self.UserMessageSent = true
					end
				end
				self.Weapon:SendWeaponAnim( ACT_VM_RECOIL2 )
				self.Weapon:SetNextSecondaryFire( CurTime() + 0.6 )
				self.Weapon:SetNextPrimaryFire( CurTime() + 0.6 )
				timer.Create("lantern_reset"..self:EntIndex(),0.02,1,function()
				
					-- Prevention of NULL entity error
					if not self:IsValid() then return end
					if not self.Owner or not IsValid(self.Owner) then return end
					
					umsg.Start("Lantern_SlappC")
						umsg.Entity(self.Owner)
						umsg.String("3")
					umsg.End()
					self.UserMessageSent = false
					self.Weapon:SendWeaponAnim( ACT_VM_RECOIL1 )
				end)
			end
		end
	end
end

function SWEP:DrawWorldModel( )
    if not IsValid( self.Owner ) then
        return self:DrawModel()
    end
    
    local offset, hand
    
    self.Hand2 = self.Hand2 or self.Owner:LookupAttachment( "anim_attachment_rh" )
    
    hand = self.Owner:GetAttachment( self.Hand2 )
    
    if not hand then
        return
    end
    
    offset = hand.Ang:Right( ) * self.Offset.Pos.Right + hand.Ang:Forward( ) * self.Offset.Pos.Forward + hand.Ang:Up( ) * self.Offset.Pos.Up
    
    hand.Ang:RotateAroundAxis( hand.Ang:Right( ), self.Offset.Ang.Right )
    hand.Ang:RotateAroundAxis( hand.Ang:Forward( ), self.Offset.Ang.Forward )
    hand.Ang:RotateAroundAxis( hand.Ang:Up( ), self.Offset.Ang.Up )
    
    self:SetRenderOrigin( hand.Pos + offset )
    self:SetRenderAngles( hand.Ang )

    self:DrawModel()
end