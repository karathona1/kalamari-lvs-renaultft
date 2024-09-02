ENT.Base = "lvs_tank_wheeldrive"

ENT.PrintName = "FT"
ENT.Author = "Kalamari"
ENT.Information = "Kalamari's WW1 Vehicles"
ENT.Category = "[LVS] - Tanks"

ENT.VehicleCategory = "Tanks"
ENT.VehicleSubCategory = "Light"

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

ENT.MDL = "models/tank_ft_female.mdl"

ENT.TurretSeatIndex = 1

ENT.AITEAM = 2

ENT.MaxHealth = 700

ENT.SpawnNormalOffset = 35

//damage system
ENT.DSArmorDamageReduction = 0.0025
ENT.DSArmorDamageReductionType = DMG_BULLET + DMG_BURN
ENT.DSArmorIgnoreForce = 2000
ENT.CannonArmorPenetration = 2400

ENT.MaxVelocity = 240
ENT.MaxVelocityReverse = 120

ENT.PhysicsDampingSpeed = 4000

ENT.EngineCurve = 0.2
ENT.EngineTorque = 180

ENT.TransGears = 3
ENT.TransGearsReverse = 1

ENT.FastSteerAngleClamp = 15
ENT.FastSteerDeactivationDriftAngle = 12

ENT.PhysicsDampingForward = true
ENT.PhysicsDampingReverse = true

ENT.lvsShowInSpawner = true

ENT.WheelBrakeAutoLockup = true
ENT.WheelBrakeLockupRPM = 15

ENT.EngineSounds = {
	{
		sound = "engine1.wav",
		Volume = 0.7,
		Pitch = 50,
		PitchMul = 25,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "engineFT.wav",
		Volume = 0.7,
		Pitch = 50,
		PitchMul = 25,
		SoundLevel = 75,
		UseDoppler = true,
	},
}

function ENT:OnSetupDataTables()
	self:AddDT( "Entity", "WeaponSeat" )
	self:AddDT( "Entity", "GunnerSeat" )
end

ENT.ExhaustPositions = {
	{
		pos = Vector(-51,-28,48),
		ang = Angle(180,55,0),
	},
}