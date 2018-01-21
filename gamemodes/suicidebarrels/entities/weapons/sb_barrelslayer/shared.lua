
// Variables that are used on both client and server

SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= "Left Click to shoot"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true		// Spawnable in singleplayer or by server admins

SWEP.ViewModel			= "models/weapons/v_pistol.mdl"
SWEP.WorldModel			= "models/weapons/w_pistol.mdl"
SWEP.UseHands = false
SWEP.Primary.Sound			= Sound( "Weapon_Pistol.Single" )
SWEP.Primary.Sound			= "Weapon_Pistol.Single"
SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 999
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Damage   		= 100


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

/*---------------------------------------------------------
   Think does nothing
---------------------------------------------------------*/
function SWEP:Think()	
end


/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/
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
	
	self.Weapon:EmitSound( self.Primary.Sound )
	self:ShootBullet( 150, 1, 0.01 )
	self:TakePrimaryAmmo( 1 )
end

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
		if IsMounted( 'cstrike' ) then
			if self then
		timer.Simple(0.3,function() if self.Owner:IsValid() then self.Weapon:EmitSound("weapons/glock/glock_clipout.wav") else end end)
	end
	if self then
		timer.Simple(0.5,function() if self.Owner:IsValid() then self.Weapon:EmitSound("weapons/glock/glock_clipin.wav") else end end)
	end
	if self then
		timer.Simple(0.5,function() if self.Owner:IsValid() then self.Weapon:EmitSound("weapons/glock/glock_slideback.wav") else end end)
	end
	if self then
		timer.Simple(0.7,function() if self.Owner:IsValid() then self.Weapon:EmitSound("weapons/glock/glock_sliderelease.wav") else end end)
	end
 		else
 			if self then
if self.Owner:IsValid() then self.Weapon:EmitSound("weapons/pistol/pistol_reload1.wav") else end
end
 		end
	end
	end
end



