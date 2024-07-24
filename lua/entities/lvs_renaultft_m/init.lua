AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sh_turret.lua" )
AddCSLuaFile( "sh_tracks.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_optics.lua" )
AddCSLuaFile( "cl_tankview.lua" )
include("shared.lua")
include("sh_turret.lua")
include("sh_tracks.lua")


function ENT:OnSpawn( PObj )
	local DriverSeat = self:AddDriverSeat( Vector(25,0,20), Angle(0,-90,0) )
	DriverSeat.HidePlayer = true

	local GunnerSeat = self:AddPassengerSeat( Vector(30,0,45), Angle(0,-90,0) )
	GunnerSeat.HidePlayer = false
	self:SetGunnerSeat( GunnerSeat )

	local ID = self:LookupAttachment( "gun_muzzle" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurret = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "cannon_shot_ft.wav", "cannon_shot_ft.wav" )
	self.SNDTurret:SetSoundLevel( 95 )
	self.SNDTurret:SetParent( self, ID )

	self:AddEngine( Vector(-10,0,65), Angle(0,-90,0) )
	self:AddFuelTank( Vector(-10,0,65), Angle(0,0,0), 800, LVS.FUELTYPE_PETROL )

	//FRONT ARMOR
	self:AddArmor( Vector(85,0,20), Angle( 0,0,0 ), Vector(-25,-25,-10), Vector(15,25,40), 400, self.FrontArmor )

	//LEFT ARMOR
	self:AddArmor( Vector(0,30,55), Angle( 0,0,0 ), Vector(-45,-7,-10), Vector(60,7,5), 300, self.SideArmor )

	//RIGHT ARMOR
	self:AddArmor( Vector(0,-30,55), Angle( 0,0,0 ), Vector(-45,-7,-10), Vector(60,7,5), 300, self.SideArmor )

	//BACK ARMOR
	self:AddArmor( Vector(-65,0,45), Angle( 0,0,0 ), Vector(-35,-20,-25), Vector(10,20,10), 300, self.BackArmor )


	//TURRET ARMOR
	local TurretArmor = self:AddArmor( Vector(35,0,70), Angle(0,0,0), Vector(-25,-25,-10), Vector(25,25,15), 800, self.TurretArmor )
	TurretArmor.OnDestroyed = function( ent, dmginfo ) if not IsValid( self ) then return end self:SetTurretDestroyed( true ) end
	TurretArmor.OnRepaired = function( ent ) if not IsValid( self ) then return end self:SetTurretDestroyed( false ) end
	TurretArmor:SetLabel( "Turret" )
	self:SetTurretArmor( TurretArmor )

	self:AddTrailerHitch( Vector(-55,0,15), LVS.HITCHTYPE_MALE )
end

-- set material on death
function ENT:OnDestroyed()
	self:SetMaterial("props/metal_damaged")
end
