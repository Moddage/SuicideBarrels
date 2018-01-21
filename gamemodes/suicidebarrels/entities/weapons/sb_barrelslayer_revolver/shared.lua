
// Variables that are used on both client and server

SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= "Left Click to shoot"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true		// Spawnable in singleplayer or by server admins

SWEP.ViewModel			= "models/weapons/v_357.mdl"
SWEP.WorldModel			= "models/weapons/w_357.mdl"

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 999
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Damage   		= 100
SWEP.HoldType = "revolver" 
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

local ShootSound = Sound( "vo/k_lab/kl_ahhhh.wav" )

/*---------------------------------------------------------
	Reload does nothing
---------------------------------------------------------*/
function SWEP:Reload()
end

function SWEP:Initialize()

	self:SetWeaponHoldType(self.HoldType)
end
/*---------------------------------------------------------
   Think does nothing
---------------------------------------------------------*/
function SWEP:Think()	
end


/*---------------------------------------------------------
	PrimaryAttack
--*/
function SWEP:CustomAmmoDisplay()
	self.AmmoDisplay = self.AmmoDisplay or {}

if GetConVar("sb_ammodisplay"):GetInt() == 0 then
	self.AmmoDisplay.Draw = false //draw the display?
elseif GetConVar("sb_ammodisplay"):GetInt() == 1 then
	self.AmmoDisplay.Draw = true
	elseif GetConVar("sb_ammodisplay"):GetInt() == 2 then
		self.AmmoDisplay.Draw = true

end

	if self.Primary.ClipSize > 0 then
		self.AmmoDisplay.PrimaryClip = self:Clip1() //amount in clip
		self.AmmoDisplay.PrimaryAmmo = self:Ammo1() //amount in reserve
	end
	if self.Secondary.ClipSize > 0 then
		self.AmmoDisplay.SecondaryClip = self:Clip2()
		self.AmmoDisplay.SecondaryAmmo = self:Ammo2()
	end

	return self.AmmoDisplay //return the table
end

function SWEP:PrimaryAttack()
	if ( !self:CanPrimaryAttack() ) then return end
if self.Owner:IsPlayer() then
	if SERVER then
	local ent = ents.Create( "prop_physics_multiplayer" )
	if ( !IsValid( ent ) ) then return end
	ent:SetModel( "models/kleiner.mdl" )
	ent:SetPos( self.Owner:EyePos() + ( self.Owner:GetAimVector() * 16 ) )
	ent:SetAngles( self.Owner:EyeAngles() )
	ent:Spawn()
	local phys = ent:GetPhysicsObject()
	if ( !IsValid( phys ) ) then ent:Remove() return end
	local velocity = self.Owner:GetAimVector()
	velocity = velocity * 9999999999999999999
	velocity = velocity + ( VectorRand() * 1 ) -- a random element
	phys:ApplyForceCenter( velocity )
	ent:SetCollisionGroup(COLLISION_GROUP_NONE)
timer.Simple(2.6,function() ent:Remove() end)
end
	self.Weapon:EmitSound( ShootSound, 100, math.Rand( 90, 145 ) )
	self:ShootBullet( 150, 1, 0.01 )
	self:TakePrimaryAmmo( 1 )
end
end
--
/*---------------------------------------------------------
	SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()	
end


function SWEP:Reload()
	if self then
	if self.ReloadingTime and CurTime() <= self.ReloadingTime then return end
 
	if ( self:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 ) then
 
		self:DefaultReload( ACT_VM_RELOAD )
                local AnimationTime = self.Owner:GetViewModel():SequenceDuration()
                self.ReloadingTime = CurTime() + AnimationTime
                self:SetNextPrimaryFire(CurTime() + AnimationTime)
                self:SetNextSecondaryFire(CurTime() + AnimationTime)
 	
                self.Weapon:EmitSound("vo/k_lab/kl_finalsequence.wav", 100, 135)

	timer.Simple(0.4,function() if self.Weapon then self.Weapon:EmitSound("vo/k_lab/kl_fiddlesticks.wav", 100, 110) end end)
	timer.Simple(0.8,function() if self.Weapon then self.Weapon:EmitSound("vo/k_lab/kl_fiddlesticks.wav", 125, 80) end end)
	timer.Simple(1.8,function() if self.Weapon then self.Weapon:EmitSound("vo/k_lab/kl_fiddlesticks.wav", 100, 120) end end)
	timer.Simple(2.6,function()  if self.Weapon then self.Weapon:EmitSound("vo/k_lab/kl_fiddlesticks.wav", 125, 145) end end)
	end
end
end



