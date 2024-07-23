ENT.Base = "lvs_tank_wheeldrive"

ENT.PrintName = "FT (8mm Mitrailleuse)"
ENT.Author = "Kalamari"
ENT.Information = "Kalamari's WW1 Vehicles"
ENT.Category = "[LVS] - Tanks"

ENT.VehicleCategory = "Tanks"
ENT.VehicleSubCategory = "RP"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/tank_ft_female.mdl"

ENT.AITEAM = 2

ENT.MaxHealth = 1300

ENT.SpawnNormalOffset = 40

//damage system
ENT.DSArmorIgnoreForce = 1800
ENT.CannonArmorPenetration = 3900

ENT.MaxVelocity = 150
ENT.MaxVelocityReverse = 100

ENT.EngineCurve = 0.2
ENT.EngineTorque = 130

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
	self:AddDT( "Entity", "GunnerSeat" )
end

//puteaux 37mm gun
function ENT:InitWeapons()
	local COLOR_WHITE = Color(255,255,255,255)

	//MACHINEGUN
	local weapon = {}
	weapon.Icon = Material("lvs/weapons/mg.png")
	weapon.Ammo = 1500
	weapon.Delay = 0.1
	weapon.HeatRateUp = 0.2
	weapon.HeatRateDown = 0.2
	weapon.Attack = function( ent )

		local ID = ent:LookupAttachment( "gun_muzzle" )
		local veh = ent:GetVehicle()
		local Muzzle = ent:GetAttachment( ID )

		if not Muzzle then return end

		local bullet = {}
		bullet.Src 	= Muzzle.Pos
		bullet.Dir 	= -Muzzle.Ang:Forward()
		bullet.Spread 	= Vector(0.01,0.01,0.01)
		bullet.TracerName = "lvs_tracer_yellow"
		bullet.Force	= 100
		bullet.HullSize = 0
		bullet.Damage	= 15
		bullet.Velocity = 30000
		bullet.Attacker = ent:GetPassenger( GunnerSeat )
		ent:LVSFireBullet( bullet )

		local effectdata = EffectData()
		effectdata:SetOrigin( bullet.Src )
		effectdata:SetNormal( bullet.Dir )
		effectdata:SetEntity( ent )
		util.Effect( "lvs_muzzle", effectdata )

		local PhysObj = ent:GetPhysicsObject()
		if IsValid( PhysObj ) then
			PhysObj:ApplyForceOffset( -bullet.Dir * 5000, bullet.Src )
		end

		veh:PlayAnimation("gun_recoil")
		ent:TakeAmmo( 1 )
	end
	weapon.StartAttack = function( ent )
		if not IsValid( ent.SNDTurretMG ) then return end
		ent.SNDTurretMG:Play()
	end
	weapon.FinishAttack = function( ent )
		if not IsValid( ent.SNDTurretMG ) then return end
		ent.SNDTurretMG:Stop()
	end
	weapon.OnOverheat = function( ent ) ent:EmitSound("lvs/overheat.wav") end
	weapon.HudPaint = function( ent, X, Y, ply )
		local ID = ent:LookupAttachment( "gun_muzzle" )

		local Muzzle = ent:GetAttachment( ID )

		if Muzzle then
			local traceTurret = util.TraceLine( {
				start = Muzzle.Pos, 
				endpos = Muzzle.Pos - Muzzle.Ang:Forward() * 50000,
				filter = ent:GetCrosshairFilterEnts()
			} )

			local MuzzlePos2D = traceTurret.HitPos:ToScreen() 

			ent:PaintCrosshairCenter( MuzzlePos2D, COLOR_WHITE )
			ent:LVSPaintHitMarker( MuzzlePos2D )
		end
	end
	weapon.OnOverheat = function( ent )
		ent:EmitSound("lvs/overheat.wav")
	end
	self:AddWeapon( weapon, 2 )

	//NOTHING
	local weapon = {}
	weapon.Icon = Material("weapons/cross.png")
	weapon.Ammo = -1
	weapon.Delay = 0
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 0
	weapon.OnSelect = function( ent )
		if ent.SetTurretEnabled then
			ent:SetTurretEnabled( false )
		end
	end
	weapon.OnDeselect = function( ent )
		if ent.SetTurretEnabled then
			ent:SetTurretEnabled( true )
		end
	end
	self:AddWeapon( weapon, 2 )
end

ENT.ExhaustPositions = {
	{
		pos = Vector(-51,-28,48),
		ang = Angle(180,55,0),
	},
}